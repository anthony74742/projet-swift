//
//  FeatureCardsGrid.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct FeatureCardsGrid: View {
    let onSummarizeAudio: () -> Void
    let onChatWithAI: () -> Void
    let onGenerateImage: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            FeatureCard(
                title: "Résumer\nun son",
                icon: "waveform",
                color: .greenBackground,
                size: .large,
                action: onSummarizeAudio
            )
            
            HStack(spacing: 12) {
                FeatureCard(
                    title: "Parler à l'IA",
                    icon: "message",
                    color: Color(red: 0.8, green: 0.6, blue: 1.0),
                    size: .small,
                    action: onChatWithAI
                )
                
                FeatureCard(
                    title: "Générer une image",
                    icon: "photo",
                    color: Color(red: 1.0, green: 0.8, blue: 0.9),
                    size: .small,
                    action: onGenerateImage
                )
            }
        }
    }
}






