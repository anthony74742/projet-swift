//
//  Conversation.swift
//  Iakadir
//
//  Created by Mac on 12.12.2024.
//


import Foundation

struct Conversation: Identifiable, Codable {
    let id: UUID
    let title: String
    let lastMessageDate: Date
    
    init(id: UUID = UUID(), title: String, lastMessageDate: Date = Date()) {
        self.id = id
        self.title = title
        self.lastMessageDate = lastMessageDate
    }
}

