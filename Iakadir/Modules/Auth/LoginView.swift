//
//  LoginView.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            BackgroundView(color: .black)
            
            VStack(spacing: 30) {
                // Logo section
                ZStack {
                    AnimatedImage(
                        imageName: "neon-effect",
                        contentMode: .fit,
                        scaleEffect: 1.2,
                        opacity: 1.0
                    )
                    .frame(maxWidth: .infinity)
                    
                    AnimatedImage(
                        imageName: "robot",
                        contentMode: .fit,
                        scaleEffect: 1.0,
                        opacity: 1.0
                    )
                    .frame(width: 100, height: 100)
                }
                
                // Title and subtitle
                VStack(spacing: 15) {
                    Text("Connecte-toi")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 5) {
                        Text("Tu n'as pas de compte ?")
                            .foregroundColor(.white)
                        
                        NavigationLink("Inscris-toi", destination: RegisterView())
                            .foregroundColor(.greenBackground)
                    }
                    .font(.system(size: 16))
                }
                
                // Login form
                VStack(spacing: 0) {
                    AuthTextField(
                        text: $viewModel.email,
                        placeholder: "Email",
                        icon: "envelope",
                        keyboardType: .emailAddress
                    )
                    .padding(.bottom, 1)
                    
                    AuthSecureField(
                        text: $viewModel.password,
                        placeholder: "Mot de passe",
                        icon: "lock"
                    )
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Login button
                CustomButton(
                    title: "Me connecter",
                    action: {
                        Task {
                            await viewModel.login()
                        }
                    },
                    font: .headline,
                    foregroundColor: .black,
                    backgroundColor: .white,
                    padding: EdgeInsets(top: 20, leading: 100, bottom: 20, trailing: 100),
                    cornerRadius: 30
                )
                .padding(.top, 20)
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                appState.isLoggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState())
    }
}

