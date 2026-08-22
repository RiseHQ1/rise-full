//
//  SplashLogo.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Prominent branding header for the Splash screen featuring the full-scale Rise sunrise logo and tagline.
public struct SplashLogo: View {
    public var isTaglineVisible: Bool
    
    public init(isTaglineVisible: Bool = true) {
        self.isTaglineVisible = isTaglineVisible
    }
    
    public var body: some View {
        VStack(spacing: RiseSpacing.xs) {
            Image("rise_sunrise_logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 210, maxHeight: 86)
                .accessibilityLabel("Rise Logo")
            
            Text("Your daily boost.")
                .font(RiseTypography.titleSmall)
                .fontWeight(.bold)
                .foregroundStyle(RiseColors.accentSecondary)
                .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 2)
                .opacity(isTaglineVisible ? 1.0 : 0.0)
                .offset(y: isTaglineVisible ? 0 : 6)
        }
    }
}

#Preview("SplashLogo") {
    SplashLogo(isTaglineVisible: true)
        .padding(RiseSpacing.xl)
        .background(RiseColors.backgroundPrimary)
}
