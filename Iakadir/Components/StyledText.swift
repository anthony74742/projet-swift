//
//  AppNameText.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

struct StyledText: View {
    var text: String
    var font: Font
    var fontWeight: Font.Weight
    var foregroundColor: Color
    var padding: EdgeInsets
    var backgroundColor: Color
    var cornerRadius: CGFloat
    
    init(
        text: String,
        font: Font = .body,
        fontWeight: Font.Weight = .regular,
        foregroundColor: Color = .primary,
        padding: EdgeInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
        backgroundColor: Color = .clear,
        cornerRadius: CGFloat = 0
    ) {
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
        self.foregroundColor = foregroundColor
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(fontWeight)
            .foregroundColor(foregroundColor)
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

struct StyledText_Previews: PreviewProvider {
    static var previews: some View {
        StyledText(
            text: "Hello, World!",
            font: .title,
            fontWeight: .bold,
            foregroundColor: .white,
            backgroundColor: .blue,
            cornerRadius: 10
        )
    }
}
