//
//  Conversation.swift
//  Iakadir
//
//  Created by digital on 13/12/2024.
//


import Foundation

struct Conversation: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let createdAt: Date
    let messages: [ChatMessage]
    var title: String {
        messages.first { $0.isUser }?.content.prefix(50).description ?? "New Conversation"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case messages
    }
}

