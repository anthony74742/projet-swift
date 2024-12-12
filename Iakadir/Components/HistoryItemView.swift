//
//  HistoryItemView.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct HistoryItemView: View {
    let item: HistoryItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.type.iconName)
                .foregroundColor(item.type.color)
                .font(.system(size: 18))
                .frame(width: 36, height: 36)
                .background(item.type.color.opacity(0.2))
                .clipShape(Circle())
            
            Text(item.text)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

