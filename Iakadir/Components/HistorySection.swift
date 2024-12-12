//
//  HistorySection.swift
//  Iakadir
//
//  Created by digital on 29/11/2024.
//


import SwiftUI

struct HistorySection: View {
    let historyItems: [HistoryItem]
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Historique")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onSeeAll) {
                    Text("Voir tout")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(historyItems) { item in
                    HistoryItemView(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}


