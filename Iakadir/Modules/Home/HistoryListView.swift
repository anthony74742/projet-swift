//
//  HistoryListView.swift
//  Iakadir
//
//  Created by digital on 13/12/2024.
//

import SwiftUI

struct HistoryListView: View {
    let conversations: [Conversation]
    let onConversationTap: (Conversation) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackgroundView(color: .black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Historique")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(conversations) { conversation in
                            Button(action: { onConversationTap(conversation) }) {
                                HStack(spacing: 12) {
                                    Image(systemName: iconName(for: conversation))
                                        .foregroundColor(.greenBackground)
                                        .font(.system(size: 18))
                                        .frame(width: 36, height: 36)
                                        .background(Color.greenBackground.opacity(0.2))
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(conversation.title)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
                                        Text(formattedDate(conversation.createdAt))
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func iconName(for conversation: Conversation) -> String {
        let firstAssistantMessage = conversation.messages.first { !$0.isUser }
        return firstAssistantMessage?.content.hasPrefix("http") == true ? "photo" : "message"
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
