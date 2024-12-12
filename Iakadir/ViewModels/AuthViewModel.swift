//
//  AuthViewModel.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


//import SwiftUI
//import Supabase
//
//class AuthViewModel: ObservableObject {
//    @Published var currentUser: User?
//    @Published var isAuthenticated = false
//    @Published var authError: String?
//    
//    private let supabase = SupabaseManager.shared
//    
//    init() {
//        currentUser = supabase.getCurrentUser()
//        isAuthenticated = currentUser != nil
//    }
//    
//    func signUp(email: String, password: String) {
//        Task {
//            do {
//                currentUser = try await supabase.signUp(email: email, password: password)
//                DispatchQueue.main.async {
//                    self.isAuthenticated = true
//                    self.authError = nil
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.authError = error.localizedDescription
//                }
//            }
//        }
//    }
//    
//    func signIn(email: String, password: String) {
//        Task {
//            do {
//                currentUser = try await supabase.signIn(email: email, password: password)
//                DispatchQueue.main.async {
//                    self.isAuthenticated = true
//                    self.authError = nil
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.authError = error.localizedDescription
//                }
//            }
//        }
//    }
//    
//    func signOut() {
//        Task {
//            do {
//                try await supabase.signOut()
//                DispatchQueue.main.async {
//                    self.currentUser = nil
//                    self.isAuthenticated = false
//                    self.authError = nil
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.authError = error.localizedDescription
//                }
//            }
//        }
//    }
//}
