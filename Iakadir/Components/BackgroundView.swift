//
//  BackgroundView.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

struct BackgroundView: View {
    var color: Color = .black
    var ignoresSafeArea: Bool = true

    var body: some View {
        color
            .ignoresSafeArea(ignoresSafeArea ? .all : [])
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(color: .black)
    }
}

