//
//  CardBackgroundModifier.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Standard surface background modifier for content cards and containers.
public struct RiseCardBackgroundModifier: ViewModifier {
    public var cornerRadius: CGFloat
    public var backgroundColor: Color
    public var borderColor: Color
    
    public init(
        cornerRadius: CGFloat = RiseRadius.large,
        backgroundColor: Color = RiseColors.surfacePrimary,
        borderColor: Color = RiseColors.borderSubtle
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
    }
    
    public func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            }
    }
}

public extension View {
    /// Applies the standard Rise surface card styling.
    func riseCardBackground(
        cornerRadius: CGFloat = RiseRadius.large,
        backgroundColor: Color = RiseColors.surfacePrimary,
        borderColor: Color = RiseColors.borderSubtle
    ) -> some View {
        self.modifier(
            RiseCardBackgroundModifier(
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                borderColor: borderColor
            )
        )
    }
}
