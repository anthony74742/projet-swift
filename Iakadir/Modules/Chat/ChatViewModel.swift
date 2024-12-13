//
//  ChatViewModel.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//


import SwiftUI
import Supabase

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputMessage: String = ""
    @Published var isLoading: Bool = false
    
    private let conversationId: UUID
    private var homeViewModel: HomeViewModel
    
    init(conversationId: UUID? = nil, homeViewModel: HomeViewModel) {
        self.conversationId = conversationId ?? UUID()
        self.homeViewModel = homeViewModel
        
        Task {
            if let existingId = conversationId {
                await loadConversation(id: existingId)
            } else {
                DispatchQueue.main.async {
                    self.messages = [ChatMessage(
                        content: "Hello, moi c'est Ugo sans H.\nQuelle est ta question ?",
                        isUser: false
                    )]
                }
            }
        }
    }
    
    private func loadConversation(id: UUID) async {
        do {
            let response: [Conversation] = try await SupabaseService.shared.client
                .from("conversations")
                .select()
                .eq("id", value: id)
                .execute()
                .value
            
            if let conversation = response.first {
                DispatchQueue.main.async {
                    self.messages = conversation.messages
                }
            }
        } catch {
            print("Error loading conversation: \(error)")
        }
    }
    
    func sendMessage() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: inputMessage, isUser: true)
        messages.append(userMessage)
        
        let messageToSend = inputMessage
        inputMessage = ""
        isLoading = true
        
        Task {
            do {
                let response = try await callOpenAI(message: messageToSend)
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let result = response.result {
                        let aiMessage = ChatMessage(content: result, isUser: false)
                        self.messages.append(aiMessage)
                        
                        Task {
                            await self.saveConversation()
                        }
                    }
                }
            } catch {
                print("Error calling OpenAI: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.messages.append(ChatMessage(
                        content: "Désolé, une erreur s'est produite. Veuillez réessayer.",
                        isUser: false
                    ))
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
            
            DispatchQueue.main.async {
                self.homeViewModel.updateLocalConversations(conversation)
            }
        } catch {
            print("Error saving conversation: \(error)")
        }
    }
    
    struct OpenAIRequest: Encodable {
        let type: String
        let query: String
        let model: String
        let userId: String
        let conversationId: String
        
        enum CodingKeys: String, CodingKey {
            case type, query, model
            case userId = "user_id"
            case conversationId = "conversation_id"
        }
    }
    
    func callOpenAI(message: String) async throws -> OpenAIResponse {
        let url = URL(string: "https://zmdgdxwqwjasuryzwepw.functions.supabase.co/openai")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let session = try? await SupabaseService.shared.client.auth.session else {
            throw NSError(domain: "ChatViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No active session"])
        }
        
        guard let user = try? await SupabaseService.shared.client.auth.user() else {
            throw NSError(domain: "ChatViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user found"])
        }
        
        request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        
        let body = OpenAIRequest(
            type: "text",
            query: message,
            model: "gpt-4o-mini",
            userId: user.id.uuidString,
            conversationId: conversationId.uuidString
        )
        
        request.httpBody = try JSONEncoder().encode(body) // Update: Using JSONEncoder
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(OpenAIResponse.self, from: data)
    }
    
    func regenerateResponse() {
        guard let lastUserMessageIndex = messages.lastIndex(where: { $0.isUser }) else {
            return
        }
        
        messages = Array(messages.prefix(through: lastUserMessageIndex))
        
        isLoading = true
        
        Task {
            do {
                if let lastUserMessage = messages.last(where: { $0.isUser }) {
                    let response = try await callOpenAI(message: lastUserMessage.content)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let result = response.result {
                            let aiMessage = ChatMessage(content: result, isUser: false)
                            self.messages.append(aiMessage)
                            
                            Task {
                                await self.saveConversation()
                            }
                        }
                    }
                }
            } catch {
                print("Error regenerating response: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.messages.append(ChatMessage(
                        content: "Désolé, une erreur s'est produite lors de la régénération. Veuillez réessayer.",
                        isUser: false
                    ))
                }
            }
        }
    }
    
    func copyMessage(_ message: ChatMessage) {
        UIPasteboard.general.string = message.content
    }
    
    func shareMessage(_ message: ChatMessage) {
        // TODO: Implement sharing logic
        print("Sharing message...")
    }
}

struct OpenAIResponse: Codable {
    let result: String?
    let conversation: Conversation?
}

