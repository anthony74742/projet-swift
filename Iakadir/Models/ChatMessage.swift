//
//  ChatMessage.swift
//  Iakadir
//
//  Created by Mac on 12.12.2024.
//


import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let conversationId: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), conversationId: UUID, content: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.conversationId = conversationId
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

