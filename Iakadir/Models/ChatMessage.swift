//
//  ChatMessage.swift
//  Iakadir
//
//  Created by digital on 13/12/2024.
//


import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case isUser = "role" // Maps to 'user' or 'assistant' in JSON
        case timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        let role = try container.decode(String.self, forKey: .isUser)
        isUser = role == "user"
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(isUser ? "user" : "assistant", forKey: .isUser)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

