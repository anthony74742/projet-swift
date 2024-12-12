//
//  CustomButton.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var font: Font
    var foregroundColor: Color
    var backgroundColor: Color
    var padding: EdgeInsets
    var cornerRadius: CGFloat
    var shadowRadius: CGFloat
    var borderColor: Color
    var borderWidth: CGFloat
    
    init(
        title: String,
        action: @escaping () -> Void,
        font: Font = .headline,
        foregroundColor: Color = .primary,
        backgroundColor: Color = .clear,
        padding: EdgeInsets = EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20),
        cornerRadius: CGFloat = 10,
        shadowRadius: CGFloat = 0,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0
    ) {
        self.title = title
        self.action = action
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(foregroundColor)
                .padding(padding)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .shadow(radius: shadowRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(
            title: "Press Me",
            action: { print("Button pressed") },
            backgroundColor: .blue,
            cornerRadius: 20,
            shadowRadius: 5,
            borderColor: .white,
            borderWidth: 2
        )
    }
}
