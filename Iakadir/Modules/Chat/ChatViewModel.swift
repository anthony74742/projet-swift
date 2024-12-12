//
//  ChatViewModel.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//


import SwiftUI
import Supabase

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputMessage: String = ""
    @Published var isLoading: Bool = false
    
    init() {
        // Add initial greeting message
        messages.append(Message(
            content: "Hello, moi c'est Ugo sans H.\nQuelle est ta question ?",
            isUser: false
        ))
    }
    
    func sendMessage() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: inputMessage, isUser: true)
        messages.append(userMessage)
        
        // Clear input field
        inputMessage = ""
        
        isLoading = true
        
        Task {
            do {
                let response = try await callOpenAI(query: userMessage.content)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.messages.append(Message(
                        content: response,
                        isUser: false
                    ))
                }
            } catch {
                print("Error calling OpenAI: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.messages.append(Message(
                        content: "Désolé, une erreur s'est produite. Veuillez réessayer.",
                        isUser: false
                    ))
                }
            }
        }
    }
    
    func callOpenAI(query: String) async throws -> String {
        let url = URL(string: "https://zmdgdxwqwjasuryzwepw.functions.supabase.co/openai")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get the current session's access token
        guard let session = try? await SupabaseService.shared.client.auth.session else {
            throw NSError(domain: "ChatViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No active session"])
        }
        
        // Use the access token from the current session
        request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        
        let body = ["type": "text","query": query, "model": "gpt-4o-mini"]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(OpenAIResponse.self, from: data)
        
        return response.result
    }
    
    func regenerateResponse() {
        // TODO: Implement regeneration logic
        print("Regenerating response...")
    }
    
    func copyMessage(_ message: Message) {
        UIPasteboard.general.string = message.content
    }
    
    func shareMessage(_ message: Message) {
        // TODO: Implement sharing logic
        print("Sharing message...")
    }
    
    struct OpenAIResponse: Codable {
        let result: String
    }
    
}

