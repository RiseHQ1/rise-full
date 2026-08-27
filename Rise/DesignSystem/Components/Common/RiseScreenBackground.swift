//
//  RiseScreenBackground.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Full-bleed atmospheric background with optional hero illustration and readability scrims.
public struct RiseScreenBackground: View {
    public var imageName: String?
    public var alignment: Alignment
    public var imageMaxHeight: CGFloat
    public var topScrimOpacity: Double
    public var bottomScrimOpacity: Double

    public init(
        imageName: String? = "SplashBackgroundPortrait",
        alignment: Alignment = .topTrailing,
        imageMaxHeight: CGFloat = 320,
        topScrimOpacity: Double = 0.35,
        bottomScrimOpacity: Double = 0.92
    ) {
        self.imageName = imageName
        self.alignment = alignment
        self.imageMaxHeight = imageMaxHeight
        self.topScrimOpacity = topScrimOpacity
        self.bottomScrimOpacity = bottomScrimOpacity
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                RiseColors.backgroundPrimary

                LinearGradient(
                    colors: [
                        Color(hex: "#120F29"),
                        RiseColors.backgroundPrimary,
                        Color(hex: "#070611"),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.72, height: imageMaxHeight)
                        .clipped()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                        .offset(y: -20)
                        .opacity(0.95)
                        .accessibilityHidden(true)
                }

                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(topScrimOpacity),
                            Color.clear,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 140)

                    Spacer()

                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color(hex: "#070611").opacity(0.55),
                            Color(hex: "#070611").opacity(bottomScrimOpacity),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.55)
                }
                .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview("RiseScreenBackground") {
    RiseScreenBackground()
}
