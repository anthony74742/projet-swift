//
//  MessageBubble.swift
//  Iakadir
//
//  Created by digital on 12/12/2024.
//


import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    let isLeft: Bool
    @State private var isShowingOptions = false
    let onRegenerate: () -> Void
    let onCopy: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        HStack {
            if !isLeft { Spacer() }
            
            VStack(alignment: isLeft ? .leading : .trailing, spacing: 8) {
                Text(message.content)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(
                        isLeft ?
                        Color(red: 0.2, green: 0.2, blue: 0.2) :
                        Color(red: 0.1, green: 0.1, blue: 0.2)
                    )
                    .cornerRadius(20)
                
                if isShowingOptions && !message.isUser {
                    HStack(spacing: 24) {
                        Button(action: onRegenerate) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Regénérer")
                            }
                            .foregroundColor(.greenBackground)
                        }
                        
                        Button(action: onCopy) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                Text("Copier")
                            }
                            .foregroundColor(.greenBackground)
                        }
                    }
                    .font(.system(size: 14, weight: .medium))
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isLeft ? .leading : .trailing)
            
            if isLeft { Spacer() }
        }
        .padding(.horizontal)
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    withAnimation {
                        isShowingOptions.toggle()
                    }
                }
        )
    }
}

