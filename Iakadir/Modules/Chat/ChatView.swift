//
//  ChatView.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//


import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(conversationId: UUID? = nil, homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(conversationId: conversationId, homeViewModel: homeViewModel))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Navigation Bar
                chatNavigationBar
                
                // Messages
                messageList
                
                // Input Bar
                inputBar
            }
        }
        .navigationBarHidden(true)
    }
    
    private var chatNavigationBar: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("Parler à l'IA")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {}) {
                Text("GPT-4")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.greenBackground)
                    .cornerRadius(20)
            }
        }
        .padding()
    }
    
    private var messageList: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in
                    MessageBubble(
                        message: message,
                        isLeft: index % 2 == 0,
                        onRegenerate: { viewModel.regenerateResponse() },
                        onCopy: { viewModel.copyMessage(message) },
                        onShare: { viewModel.shareMessage(message) }
                    )
                }
            }
            .padding(.vertical)
        }
    }
    
    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Écris une demande ici", text: $viewModel.inputMessage)
                .padding(16)
                .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                .cornerRadius(25)
                .foregroundColor(.white)
            
            Button(action: { viewModel.sendMessage() }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background(Color.greenBackground)
                    .clipShape(Circle())
            }
            .disabled(viewModel.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(homeViewModel: HomeViewModel())
    }
}

