//
//  FeatureCard.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct FeatureCard: View {
    enum Size {
        case small, large
    }
    
    let title: String
    let icon: String
    let color: Color
    let size: Size
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(color.opacity(0.3)))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: size == .large ? 24 : 18, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                

                

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: size == .large ? .infinity : 120)
            .background(color)
            .cornerRadius(24)
        }
    }
}

