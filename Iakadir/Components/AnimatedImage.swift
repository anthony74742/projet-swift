//
//  AnimatedImage.swift
//  Iakadir
//
//  Created by digital on 28/11/2024.
//

import SwiftUI

struct AnimatedImage: View {
    var imageName: String
    var contentMode: ContentMode
    var scaleEffect: CGFloat
    var opacity: Double
    var animation: Animation?
    
    init(
        imageName: String,
        contentMode: ContentMode = .fit,
        scaleEffect: CGFloat = 1.0,
        opacity: Double = 1.0,
        animation: Animation? = .default
    ) {
        self.imageName = imageName
        self.contentMode = contentMode
        self.scaleEffect = scaleEffect
        self.opacity = opacity
        self.animation = animation
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .scaleEffect(scaleEffect)
            .opacity(opacity)
            .animation(animation, value: scaleEffect)
            .animation(animation, value: opacity)
    }
}

struct AnimatedImage_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedImage(
            imageName: "example",
            scaleEffect: 1.2,
            opacity: 0.8,
            animation: .easeInOut(duration: 1.0)
        )
    }
}	
