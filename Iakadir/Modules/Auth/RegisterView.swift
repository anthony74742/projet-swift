//
//  RegisterView.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode
    
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
                    Text("Inscris-toi")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 5) {
                        Text("Déjà un compte ?")
                            .foregroundColor(.white)
                        
                        Button("Connecte-toi") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.greenBackground)
                    }
                    .font(.system(size: 16))
                }
                
                // Register form
                VStack(spacing: 0) {
                    AuthTextField(
                        text: $viewModel.name,
                        placeholder: "Nom",
                        icon: "person"
                    )
                    .padding(.bottom, 1)
                    
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
                
                // Register button
                CustomButton(
                    title: "M'inscrire",
                    action: {
                        Task {
                            await viewModel.register()
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            HomeView()
        }
    }
}

#Preview {
    RegisterView()
}
