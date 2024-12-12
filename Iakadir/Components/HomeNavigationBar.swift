//
//  HomeNavigationBar.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct HomeNavigationBar: View {
    let username: String
    let onMenuTap: () -> Void
    let onProTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onMenuTap) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.white)
                    .font(.title2)
                    .frame(width:40 , height: 40)
                    .background(Color(hex: "#171717"))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .opacity(0.7)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Hello, \(username)")
                    .foregroundColor(.white)
                    .font(.caption)
                Text("👋")
            }
            
            Spacer()
            
            Button(action: onProTap) {
                HStack {
                    Text("PRO")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "star.fill") // Utilisation de l'icône d'étoile SF
                        .foregroundColor(.yellow) // Couleur de l'étoile, tu peux la modifier
                        .font(.system(size: 16)) // Taille de l'étoile
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color(hex: "#191B29"))
                        .overlay(
                            Capsule()
                                .stroke(Color.greenBackground, lineWidth: 1) // Bordure de la capsule
                        )
                )
            }

        }
        .padding()
    }
}
