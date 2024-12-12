//
//  ChatStorageManager.swift
//  Iakadir
//
//  Created by Mac on 12.12.2024.
//


import Foundation

class ChatStorageManager {
    static let shared = ChatStorageManager()
    
    private let conversationsKey = "savedConversations"
    private let messagesKey = "savedMessages"
    
    private init() {}
    
    func saveConversation(_ conversation: Conversation) {
        var conversations = getConversations()
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
        } else {
            conversations.append(conversation)
        }
        
        if let encoded = try? JSONEncoder().encode(conversations) {
            UserDefaults.standard.set(encoded, forKey: conversationsKey)
        }
    }
    
    func getConversations() -> [Conversation] {
        if let data = UserDefaults.standard.data(forKey: conversationsKey),
           let conversations = try? JSONDecoder().decode([Conversation].self, from: data) {
            return conversations
        }
        return []
    }
    
    func saveMessages(_ messages: [ChatMessage], for conversationId: UUID) {
        var allMessages = getAllMessages()
        allMessages[conversationId] = messages
        
        if let encoded = try? JSONEncoder().encode(allMessages) {
            UserDefaults.standard.set(encoded, forKey: messagesKey)
        }
    }
    
    func getMessages(for conversationId: UUID) -> [ChatMessage] {
        let allMessages = getAllMessages()
        return allMessages[conversationId] ?? []
    }
    
    private func getAllMessages() -> [UUID: [ChatMessage]] {
        if let data = UserDefaults.standard.data(forKey: messagesKey),
           let messages = try? JSONDecoder().decode([UUID: [ChatMessage]].self, from: data) {
            return messages
        }
        return [:]
    }
}

