//
//  RiseSurfaceCard.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Standard opaque content card using Rise surface tokens.
///
/// Designed as the workhorse container for list items, reflection entries, and content blocks.
public struct RiseSurfaceCard<Content: View>: View {
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public var backgroundColor: Color
    public var borderColor: Color
    public let content: () -> Content
    
    public init(
        cornerRadius: CGFloat = RiseRadius.large,
        padding: CGFloat = RiseSpacing.md,
        backgroundColor: Color = RiseColors.surfacePrimary,
        borderColor: Color = RiseColors.borderSubtle,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.content = content
    }
    
    public var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .riseShadow(RiseShadows.elevationLow)
    }
}

#Preview("RiseSurfaceCard") {
    VStack(spacing: RiseSpacing.md) {
        RiseSurfaceCard {
            VStack(alignment: .leading, spacing: RiseSpacing.xs) {
                Text("Standard Surface Card")
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("A grounded container with comfortable internal padding and subtle border separation.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
            }
        }
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
