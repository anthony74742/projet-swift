//
//  LoginViewModel.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    func login() async {
        do {
            let success = try await SupabaseService.shared.login(email: email, password: password)
            DispatchQueue.main.async {
                self.isAuthenticated = success
                if !success {
                    self.showError = true
                    self.errorMessage = "Échec de la connexion. Veuillez vérifier vos identifiants."
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
