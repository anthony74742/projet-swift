//
//  HistoryItem.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct HistoryItem: Identifiable {
    let id = UUID()
    let type: HistoryType
    let text: String
}

enum HistoryType {
    case audio
    case chat
    case image
    
    var iconName: String {
        switch self {
        case .audio: return "waveform"
        case .chat: return "message"
        case .image: return "photo"
        }
    }
    
    var color: Color {
        switch self {
        case .audio: return .greenBackground
        case .chat: return Color(red: 0.8, green: 0.6, blue: 1.0)
        case .image: return Color(red: 1.0, green: 0.8, blue: 0.9)
        }
    }
}

