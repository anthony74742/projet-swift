//
//  RegisterViewModel.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    func register() async {
        do {
            isAuthenticated = try await SupabaseService.shared.signUp(email: email, password: password, name: name)
        } catch {
            DispatchQueue.main.async {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
