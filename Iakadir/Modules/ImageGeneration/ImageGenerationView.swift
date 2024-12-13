//
//  ImageGenerationView.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//
import SwiftUI

struct ImageGenerationView: View {
    @StateObject private var viewModel: ImageGenerationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(conversationId: UUID? = nil, homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: ImageGenerationViewModel(conversationId: conversationId, homeViewModel: homeViewModel))
    }
    
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
                
                // Conversation
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.messages) { message in
                            if message.isUser {
                                UserPromptView(content: message.content)
                            } else {
                                GeneratedImageView(imageUrl: message.content, viewModel: viewModel)
                            }
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
                    .disabled(viewModel.inputPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

struct UserPromptView: View {
    let content: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(content)
                .padding(12)
                .background(Color.greenBackground.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

struct GeneratedImageView: View {
    let imageUrl: String
    let viewModel: ImageGenerationViewModel
    @State private var isShowingOptions = false
    @State private var isDownloading = false
    @State private var downloadProgress: Float = 0.0
    
    var body: some View {
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
        .onTapGesture {
            isShowingOptions.toggle()
        }
        .overlay(
            VStack {
                if isShowingOptions {
                    HStack(spacing: 24) {
                        Button(action: downloadImage) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.down.circle")
                                Text("Télécharger")
                            }
                            .foregroundColor(.greenBackground)
                        }
                        
                        Button(action: copyImageURL) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                Text("Copier URL")
                            }
                            .foregroundColor(.greenBackground)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                }
            }
        )
        .overlay(
            Group {
                if isDownloading {
                    ProgressView(value: downloadProgress)
                        .progressViewStyle(CircularProgressViewStyle(tint: .greenBackground))
                        .scaleEffect(2)
                }
            }
        )
    }
    
    private func downloadImage() {
        guard let url = URL(string: imageUrl) else { return }
        
        isDownloading = true
        downloadProgress = 0.1
        
        Task {
            do {
                let imageData = try await viewModel.downloadImage(url: url)
                downloadProgress = 0.5
                
                viewModel.saveImage(imageData) { result in
                    DispatchQueue.main.async {
                        isDownloading = false
                        downloadProgress = 0.0
                        
                        switch result {
                        case .success(let savedURL):
                            print("Image sauvegardée avec succès à: \(savedURL)")
                            // Vous pouvez ajouter ici une notification pour informer l'utilisateur que le téléchargement est terminé
                        case .failure(let error):
                            print("Erreur lors de la sauvegarde de l'image: \(error)")
                            // Vous pouvez ajouter ici une alerte pour informer l'utilisateur de l'échec du téléchargement
                        }
                    }
                }
            } catch {
                print("Erreur lors du téléchargement de l'image: \(error)")
                DispatchQueue.main.async {
                    isDownloading = false
                    downloadProgress = 0.0
                    // Vous pouvez ajouter ici une alerte pour informer l'utilisateur de l'échec du téléchargement
                }
            }
        }
    }
    
    private func copyImageURL() {
        viewModel.copyImageURL(imageUrl)
    }
}




//struct ImageGenerationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageGenerationView()
//    }
//}
