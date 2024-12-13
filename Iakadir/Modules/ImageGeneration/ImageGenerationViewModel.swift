//
//  ImageGenerationViewModel.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//

import SwiftUI
import Supabase
import UniformTypeIdentifiers

class ImageGenerationViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputPrompt: String = ""
    @Published var isLoading: Bool = false
    
    private let conversationId: UUID
    private var homeViewModel: HomeViewModel
    
    init(conversationId: UUID? = nil, homeViewModel: HomeViewModel) {
        self.conversationId = conversationId ?? UUID()
        self.homeViewModel = homeViewModel
        
        if let id = conversationId {
            loadExistingConversation(id: id)
        }
    }
    
    private func loadExistingConversation(id: UUID) {
        if let conversation = homeViewModel.conversations.first(where: { $0.id == id }) {
            self.messages = conversation.messages
        }
    }
    
    func generateImage() {
        guard !inputPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        
        let userMessage = ChatMessage(content: inputPrompt, isUser: true)
        messages.append(userMessage)
        
        Task {
            do {
                let imageUrl = try await callImageGenerationAPI(prompt: inputPrompt)
                await MainActor.run {
                    let aiMessage = ChatMessage(content: imageUrl, isUser: false)
                    self.messages.append(aiMessage)
                    self.isLoading = false
                    Task {
                        await self.saveConversation()
                    }
                    self.inputPrompt = ""
                }
            } catch {
                print("Error generating image: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func saveConversation() async {
        guard let user = try? await SupabaseService.shared.client.auth.user() else { return }
        
        let conversation = Conversation(
            id: conversationId,
            userId: user.id,
            createdAt: Date(),
            messages: messages
        )
        
        do {
            try await SupabaseService.shared.client
                .from("conversations")
                .upsert([conversation])
                .execute()
            
            await MainActor.run {
                self.homeViewModel.updateLocalConversations(conversation)
            }
        } catch {
            print("Error saving conversation: \(error)")
        }
    }
    
    func callImageGenerationAPI(prompt: String) async throws -> String {
        let url = URL(string: "https://zmdgdxwqwjasuryzwepw.functions.supabase.co/openai")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let session = try? await SupabaseService.shared.client.auth.session else {
            throw NSError(domain: "ImageGenerationViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No active session"])
        }
        
        request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        
        let body = ["type": "image", "query": prompt, "model": "dall-e-3"]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(ImageGenerationResponse.self, from: data)
        
        return response.imageUrl
    }
    
    func downloadImage(url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func copyImageURL(_ url: String) {
        UIPasteboard.general.string = url
    }
    
    func saveImage(_ imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        do {
            try imageData.write(to: tempURL)
            
            DispatchQueue.main.async {
                let documentPicker = UIDocumentPickerViewController(forExporting: [tempURL], asCopy: true)
                documentPicker.shouldShowFileExtensions = true
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first,
                   let rootViewController = window.rootViewController {
                    documentPicker.delegate = ImageSaveDelegate(completion: completion)
                    rootViewController.present(documentPicker, animated: true, completion: nil)
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

class ImageSaveDelegate: NSObject, UIDocumentPickerDelegate {
    let completion: (Result<URL, Error>) -> Void
    
    init(completion: @escaping (Result<URL, Error>) -> Void) {
        self.completion = completion
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            completion(.failure(NSError(domain: "ImageSaveDelegate", code: 0, userInfo: [NSLocalizedDescriptionKey: "No URL selected"])))
            return
        }
        completion(.success(url))
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion(.failure(NSError(domain: "ImageSaveDelegate", code: 1, userInfo: [NSLocalizedDescriptionKey: "Document picker was cancelled"])))
    }
}

struct ImageGenerationResponse: Codable {
    let imageUrl: String
}

