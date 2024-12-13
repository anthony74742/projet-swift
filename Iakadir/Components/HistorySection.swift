//
//  HistorySection.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct HistorySection: View {
    let conversations: [Conversation]
    let onConversationTap: (Conversation) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Historique")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            ForEach(conversations.prefix(5)) { conversation in
                Button(action: { onConversationTap(conversation) }) {
                    HStack {
                        Image(systemName: "message")
                            .foregroundColor(.greenBackground)
                        Text(conversation.title)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
