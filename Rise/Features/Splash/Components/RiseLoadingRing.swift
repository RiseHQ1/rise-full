//
//  RiseLoadingRing.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Custom animated loading ring for Rise featuring the signature purple-to-warm-gold gradient.
public struct RiseLoadingRing: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isRotating: Bool = false
    
    public var size: CGFloat
    public var lineWidth: CGFloat
    
    public init(size: CGFloat = 26, lineWidth: CGFloat = 2.5) {
        self.size = size
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0.08, to: 0.88)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#8B5CF6"), // Rise Purple
                        Color(hex: "#C084FC"), // Lavender Accent
                        Color(hex: "#EC4899"), // Rose / Pink Accent
                        Color(hex: "#F59E0B"), // Warm Amber
                        Color(hex: "#FBBF24"), // Gold Highlight
                        Color(hex: "#8B5CF6")  // Loop back to Purple
                    ]),
                    center: .center
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isRotating && !reduceMotion ? 360 : 0))
            .onAppear {
                if !reduceMotion {
                    withAnimation(Animation.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                        isRotating = true
                    }
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Loading")
    }
}

#Preview("RiseLoadingRing") {
    VStack(spacing: RiseSpacing.lg) {
        RiseLoadingRing(size: 26, lineWidth: 2.5)
        RiseLoadingRing(size: 40, lineWidth: 3.5)
    }
    .padding(RiseSpacing.xl)
    .background(RiseColors.backgroundPrimary)
}
