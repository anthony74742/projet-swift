//
//  HomeViewModel.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var username = ""
    @Published var historyItems: [HistoryItem] = []
    @Published var showProView = false
    @Published var isShowingSidebar = false
    @Published var isLoggedIn = true
    @Published var shouldNavigateToLogin = false
    
    func loadUserProfile() async {
        do {
            let profile = try await SupabaseService.shared.getUserProfile()
            DispatchQueue.main.async {
                self.username = profile.name
            }
        } catch {
            print("Error loading user profile: \(error)")
        }
    }
    
    func toggleMenu() {
            print("Toggle menu")
        }
        
        func upgradeToPro() {
            showProView = true
        }
        
        func summarizeAudio() {
            print("Summarize audio")
        }
        
        func chatWithAI() {
            print("Chat with AI")
        }
        
        func generateImage() {
            print("Generate image")
        }
        
        func seeAllHistory() {
            print("See all history")
        }

        func toggleSidebar() {
            isShowingSidebar.toggle()
        }

    func logout() {
        Task {
            await SupabaseService.shared.logout()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }
}

