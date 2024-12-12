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
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(color: .black)

                VStack(spacing: 0) { // Réduisez l'espacement ici si nécessaire
                    // Top Navigation
                    HomeNavigationBar(
                        username: viewModel.username,
                        onMenuTap: viewModel.toggleSidebar,
                        onProTap: viewModel.upgradeToPro
                    )
                    .padding(.top, 1) // Ajustez ce padding si nécessaire
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            // Main heading
                            Text("Qu'est-ce que tu\nveux faire ?")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .padding(.horizontal)
                            
                            // Feature cards grid
                            FeatureCardsGrid(
                                onSummarizeAudio: viewModel.summarizeAudio,
                                onChatWithAI: { isShowingChatView = true },
                                onGenerateImage: { isShowingImageGenerationView = true }
                            )
                            .padding(.horizontal)
                            
                            // History section
                            HistorySection(
                                historyItems: viewModel.historyItems,
                                onSeeAll: viewModel.seeAllHistory
                            )
                            .padding(.top, 20)
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
                NavigationLink(destination: ChatView(), isActive: $isShowingChatView) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(destination: ImageGenerationView(), isActive: $isShowingImageGenerationView) {
                    EmptyView()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Assurez-vous d'utiliser le bon style de navigation
        .onAppear {
            Task {
                await viewModel.loadUserProfile()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showProView) {
            ProView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppState())
    }
}

