//
//  HomeView.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @State private var isShowingChatView = false
    @State private var isShowingImageGenerationView = false
    @State private var isShowingHistoryListView = false
    @State private var selectedConversationId: UUID?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(color: .black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    HomeNavigationBar(
                        username: viewModel.username,
                        onMenuTap: viewModel.toggleSidebar,
                        onProTap: viewModel.upgradeToPro
                    )
                    .padding(.top, 1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            Text("Qu'est-ce que tu\nveux faire ?")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .padding(.horizontal)
                            
                            FeatureCardsGrid(
                                onSummarizeAudio: viewModel.summarizeAudio,
                                onChatWithAI: {
                                    selectedConversationId = nil
                                    isShowingChatView = true
                                },
                                onGenerateImage: {
                                    selectedConversationId = nil
                                    isShowingImageGenerationView = true
                                }
                            )
                            .padding(.horizontal)
                            
                            if !viewModel.conversations.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("Historique")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Button(action: { isShowingHistoryListView = true }) {
                                            Text("Voir tout")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    ForEach(viewModel.conversations.prefix(3)) { conversation in
                                        Button(action: { onConversationTap(conversation) }) {
                                            HStack(spacing: 12) {
                                                Image(systemName: iconName(for: conversation))
                                                    .foregroundColor(.greenBackground)
                                                    .font(.system(size: 18))
                                                    .frame(width: 36, height: 36)
                                                    .background(Color.greenBackground.opacity(0.2))
                                                    .clipShape(Circle())
                                                
                                                Text(conversation.title)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                
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
                                .padding(.horizontal)
                                .padding(.top, 20)
                            }
                        }
                    }
                }
                
                SidebarMenu(isShowing: $viewModel.isShowingSidebar, onLogout: {
                    viewModel.logout()
                    appState.isLoggedIn = false
                })
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: ChatView(conversationId: selectedConversationId, homeViewModel: viewModel),
                    isActive: $isShowingChatView
                ) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(
                    destination: ImageGenerationView(conversationId: selectedConversationId, homeViewModel: viewModel),
                    isActive: $isShowingImageGenerationView
                ) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(
                    destination: HistoryListView(conversations: viewModel.conversations, onConversationTap: onConversationTap),
                    isActive: $isShowingHistoryListView
                ) {
                    EmptyView()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            Task {
                await viewModel.loadUserProfile()
                await viewModel.loadConversations()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showProView) {
            ProView()
        }
    }
    
    func onConversationTap(_ conversation: Conversation) {
        selectedConversationId = conversation.id
        let firstAssistantMessage = conversation.messages.first { !$0.isUser }
        isShowingImageGenerationView = firstAssistantMessage?.content.hasPrefix("http") == true
        isShowingChatView = !isShowingImageGenerationView
    }
    
    func iconName(for conversation: Conversation) -> String {
        let firstAssistantMessage = conversation.messages.first { !$0.isUser }
        return firstAssistantMessage?.content.hasPrefix("http") == true ? "photo" : "message"
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppState())
    }
}

