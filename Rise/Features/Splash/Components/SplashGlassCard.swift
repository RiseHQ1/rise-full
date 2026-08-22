//
//  SplashGlassCard.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Dark translucent glass information card tailored for the Rise splash screen.
///
/// Features a dark purple/indigo tinted translucent glass backdrop, hairline highlight border,
/// 3D glossy purple heart asset, and high-contrast typography.
public struct SplashGlassCard: View {
    public init() {}
    
    public var body: some View {
        HStack(spacing: RiseSpacing.md) {
            // 3D Purple Heart Tile
            Image("rise_heart_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)
                .shadow(color: RiseColors.accentPrimary.opacity(0.35), radius: 10, x: 0, y: 4)
                .accessibilityHidden(true)
            
            // Text Content
            VStack(alignment: .leading, spacing: RiseSpacing.xxs) {
                Text("Start your day with purpose")
                    .font(RiseTypography.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(RiseColors.textPrimary)
                
                Text("Daily motivation, reflections\nand progress that matters.")
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineSpacing(2)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, RiseSpacing.md)
        .padding(.vertical, RiseSpacing.md)
        .background {
            ZStack {
                // Base dark indigo tint
                RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous)
                    .fill(Color(hex: "#100C24").opacity(0.72))
                
                // Translucent material layer
                RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(0.4)
                
                // Subtle purple atmospheric tint
                RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                RiseColors.accentPrimary.opacity(0.18),
                                Color(hex: "#100C24").opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            RiseColors.accentPrimary.opacity(0.45),
                            RiseColors.borderSubtle.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous))
        .riseShadow(RiseShadows.elevationMedium)
        .accessibilityElement(children: .combine)
    }
}

#Preview("SplashGlassCard") {
    SplashGlassCard()
        .padding(RiseSpacing.lg)
        .background(RiseColors.backgroundPrimary)
}
