//
//  ImageGenerationView.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//


import SwiftUI

struct ImageGenerationView: View {
    @StateObject private var viewModel = ImageGenerationViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Navigation Bar
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Générer une image")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("DALL-E")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.greenBackground)
                            .cornerRadius(20)
                    }
                }
                .padding()
                
                // Generated Images
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.generatedImages, id: \.self) { imageUrl in
                            AsyncImage(url: URL(string: imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 300)
                                        .cornerRadius(20)
                                case .failure:
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Input Bar
                HStack(spacing: 12) {
                    TextField("Décris l'image à générer", text: $viewModel.inputPrompt)
                        .padding(16)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                        .cornerRadius(25)
                        .foregroundColor(.white)
                    
                    Button(action: { viewModel.generateImage() }) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                            .background(Color.greenBackground)
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.inputPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ImageGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGenerationView()
    }
}

