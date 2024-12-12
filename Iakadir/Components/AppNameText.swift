//
//  AppNameText.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

struct AppNameText: View {
    var text: String
    var font: Font = .largeTitle
    var fontWeight: Font.Weight = .regular
    var foregroundColor: Color = .black
    var padding: EdgeInsets = EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30)
    var backgroundColor: Color = .green
    var cornerRadius: CGFloat = 180

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

struct AppNameText_Previews: PreviewProvider {
    static var previews: some View {
        AppNameText(text: "Iakadir", font: .largeTitle, fontWeight: .bold, foregroundColor: .white)
    }
}
