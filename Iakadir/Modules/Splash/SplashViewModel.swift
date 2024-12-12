//
//  SplashViewModel.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//

import SwiftUI

class SplashViewModel: ObservableObject {
    @Published var animationState: AnimationState = .initial
    @Published var showAppName = false
    @Published var showButton = false
    
    enum AnimationState {
        case initial, animated, zoomed
    }
    
    func startInitialAnimation() {
        withAnimation(.easeInOut(duration: AppConstants.initialAnimationDuration)) {
            animationState = .animated
        }
    }
    
    func handleTapGesture() {
        withAnimation(.easeInOut(duration: AppConstants.zoomAnimationDuration)) {
            animationState = .zoomed
        }
        
        withAnimation(.easeInOut(duration: AppConstants.zoomAnimationDuration).delay(AppConstants.appNameDelay)) {
            showAppName = true
        }
        
        withAnimation(.easeInOut(duration: AppConstants.zoomAnimationDuration).delay(AppConstants.buttonDelay)) {
            showButton = true
        }
    }
}


