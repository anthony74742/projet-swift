//
//  SupabaseService.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//

import Foundation
import Supabase
import SwiftKeychainWrapper

class SupabaseService {
    static let shared = SupabaseService()
    
    public let client: SupabaseClient

    private init() {
        let supabaseUrl = URL(string: "https://zmdgdxwqwjasuryzwepw.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InptZGdkeHdxd2phc3VyeXp3ZXB3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI4NzU4MTcsImV4cCI6MjA0ODQ1MTgxN30.JWJp8u1UqtkUz5dghiFaUYi-bj1lUPEV8PJ0HWPflbY"
        self.client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }
    
    func isAuthenticated() async -> Bool {
        guard let jwtToken = KeychainWrapper.standard.string(forKey: "PersonaBotJWTToken") else {
            return false
        }
        
        do {
            _ = try await self.client.auth.user()
            return true
        } catch {
            return false
        }
    }
    
    func signUp(email: String, password: String, name: String) async -> Bool {
        do {
            let authResponse = try await self.client.auth.signUp(email: email, password: password, data: ["username": .string(name)])
            if let session = authResponse.session {
                let accessToken = session.accessToken
                let saveSuccessful = KeychainWrapper.standard.set(accessToken, forKey: "PersonaBotJWTToken")
                if saveSuccessful {
                    print("JWT token sauvegardé avec succès après l'inscription")
                    // Enregistrer le profil utilisateur
                    let user = authResponse.user
//                    try await updateUserProfile(userId: user.id, name: name)
                    return true
                } else {
                    print("Échec de la sauvegarde du JWT token après l'inscription")
                    return false
                }
            } else {
                print("Inscription réussie, mais aucune session créée")
                return false
            }
        } catch {
            print("Erreur lors de l'inscription : \(error)")
            return false
        }
    }

    func login(email: String, password: String) async -> Bool {
        do {
            let authResponse = try await self.client.auth.signIn(email: email, password: password)
            let accessToken = authResponse.accessToken
            print(accessToken)
            let saveSuccessful: Bool = KeychainWrapper.standard.set(accessToken, forKey: "PersonaBotJWTToken")
            if saveSuccessful {
                print("JWT token sauvegardé avec succès")
                return true
            } else {
                print("Échec de la sauvegarde du JWT token")
                return false
            }
        } catch {
            print("Erreur lors de la connexion : \(error)")
            return false
        }
    }

    func logout() async {
        do {
            try await self.client.auth.signOut()
            KeychainWrapper.standard.removeObject(forKey: "PersonaBotJWTToken")
            print("Déconnexion réussie")
        } catch {
            print("Erreur lors de la déconnexion : \(error)")
        }
    }
    
    func getUserProfile() async throws -> UserProfile {
            guard let user = try? await client.auth.user() else {
                throw AuthError.userNotFound
            }
            
            // Convertir l'UUID en minuscules
            let lowerCaseUserId = user.id
        
            print("ID du profil : \(lowerCaseUserId)")
            
            let profiles: [UserProfile] = try await client
                .from("profiles")
                .select()
                .eq("id", value: lowerCaseUserId)
                .execute()
                .value
            
            guard let profile = profiles.first else {
                throw AuthError.profileNotFound
            }
            
            return profile
        }
}

struct UserProfile: Decodable {
    let id: UUID
    let name: String
}

enum AuthError: Error {
    case invalidCredentials
    case signUpFailed
    case tokenSaveFailed
    case noSessionCreated
    case unknownError
    case userNotFound
    case profileNotFound
    case userMismatch
}

