//
//  SplashView.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    @State private var showLogin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(color: .black)
                
                AnimatedImage(
                    imageName: "neon-effect",
                    contentMode: .fit,
                    scaleEffect: scaleEffect(for: .neonEffect),
                    opacity: viewModel.animationState == .initial ? 0 : 1,
                    animation: .easeInOut(duration: AppConstants.initialAnimationDuration)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                AnimatedImage(
                    imageName: "robot",
                    contentMode: .fit,
                    scaleEffect: scaleEffect(for: .robot),
                    opacity: viewModel.animationState == .initial ? 0 : 1,
                    animation: .easeInOut(duration: AppConstants.initialAnimationDuration)
                )
                .frame(width: AppConstants.imageSize, height: AppConstants.imageSize)
                
                VStack {
                    if viewModel.showAppName {
                        StyledText(
                            text: "Iakadir",
                            font: .largeTitle,
                            fontWeight: .bold,
                            foregroundColor: .black,
                            padding: EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30),
                            backgroundColor: Color.greenBackground,
                            cornerRadius: AppConstants.appNameCornerRadius
                        )
                        .transition(.opacity)
                    }
                    Spacer()
                    
                    if viewModel.showButton {
                        NavigationLink(destination: LoginView(), isActive: $showLogin) {
                            CustomButton(
                                title: "Commencer",
                                action: {
                                    showLogin = true
                                },
                                font: .headline,
                                foregroundColor: .black,
                                backgroundColor: .white,
                                padding: EdgeInsets(top: 20, leading: 100, bottom: 20, trailing: 100),
                                cornerRadius: AppConstants.buttonCornerRadius,
                                shadowRadius: 10
                            )
                            
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.vertical, AppConstants.verticalPadding)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.startInitialAnimation()
        }
        .onTapGesture {
            viewModel.handleTapGesture()
        }
    }
    
    private func scaleEffect(for image: ImageType) -> CGFloat {
        switch viewModel.animationState {
        case .initial:
            return AppConstants.initialScale
        case .animated:
            return AppConstants.animatedScale
        case .zoomed:
            return image == .robot ? AppConstants.zoomedRobotScale : AppConstants.zoomedNeonScale
        }
    }
    
    private enum ImageType {
        case robot, neonEffect
    }
}

#Preview {
    SplashView()
}
