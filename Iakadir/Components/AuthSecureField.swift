//
//  AuthSecureField.swift
//  Iakadir
//
//  Created by Anthony on 28/11/2024.
//


import SwiftUI

struct AuthSecureField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    @State private var isSecured = true
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.greenBackground)
                .frame(width: 20)
            
            if isSecured {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.black)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.black)
            }
            
            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
    }
}