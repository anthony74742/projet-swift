//
//  HomeViewModel.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//

import SwiftUI
import Supabase

class HomeViewModel: ObservableObject {
    @Published var username = ""
    @Published var conversations: [Conversation] = []
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
    
    func loadConversations() async {
        do {
            guard let user = try? await SupabaseService.shared.client.auth.user() else { return }
            
            let response: [Conversation] = try await SupabaseService.shared.client
                .from("conversations")
                .select()
                .eq("user_id", value: user.id)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.conversations = response
            }
        } catch {
            print("Error loading conversations: \(error)")
        }
    }
    
    func updateLocalConversations(_ newConversation: Conversation) {
        DispatchQueue.main.async {
            if let index = self.conversations.firstIndex(where: { $0.id == newConversation.id }) {
                self.conversations[index] = newConversation
            } else {
                self.conversations.insert(newConversation, at: 0)
            }
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
                self.shouldNavigateToLogin = true
            }
        }
    }
}

