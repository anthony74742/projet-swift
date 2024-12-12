//
//  IakadirApp.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

@main
struct IakadirApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if appState.isLoggedIn {
                    HomeView()
                        .environmentObject(appState)
                } else {
                    LoginView()
                        .environmentObject(appState)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        Task {
            let isAuthenticated = await SupabaseService.shared.isAuthenticated()
            DispatchQueue.main.async {
                self.isLoggedIn = isAuthenticated
            }
        }
    }
}

