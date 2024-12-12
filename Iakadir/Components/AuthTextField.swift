	//
//  AuthTextField.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//

import SwiftUI

struct AuthTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.greenBackground)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
    }
}
