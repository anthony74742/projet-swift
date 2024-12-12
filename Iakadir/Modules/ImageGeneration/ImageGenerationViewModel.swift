//
//  ImageGenerationViewModel.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//


import SwiftUI
import Supabase

class ImageGenerationViewModel: ObservableObject {
    @Published var generatedImages: [String] = []
    @Published var inputPrompt: String = ""
    @Published var isLoading: Bool = false
    
    func generateImage() {
        guard !inputPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                let imageUrl = try await callImageGenerationAPI(prompt: inputPrompt)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.generatedImages.insert(imageUrl, at: 0)
                    self.inputPrompt = ""
                }
            } catch {
                print("Error generating image: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    // You can add more detailed error handling here if needed
                }
            }
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
}

struct ImageGenerationResponse: Codable {
    let imageUrl: String
}
