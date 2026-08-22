//
//  LiquidGlassModifier.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Standard glassmorphic styling modifier using native SwiftUI material and hairline strokes.
///
/// Designed for floating navigation bars, tab bars, interactive controls, sheets, and compact badges.
public struct RiseLiquidGlassModifier: ViewModifier {
    public var cornerRadius: CGFloat
    public var tintColor: Color?
    public var strokeColor: Color
    public var strokeWidth: CGFloat
    
    public init(
        cornerRadius: CGFloat = RiseRadius.large,
        tintColor: Color? = nil,
        strokeColor: Color = RiseColors.borderSubtle.opacity(0.7),
        strokeWidth: CGFloat = 1
    ) {
        self.cornerRadius = cornerRadius
        self.tintColor = tintColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
    
    public func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    if let tintColor {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(tintColor.opacity(0.12))
                    }
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            }
    }
}

public extension View {
    /// Applies the standard Rise native Liquid Glass styling to the view.
    func riseGlass(
        cornerRadius: CGFloat = RiseRadius.large,
        tintColor: Color? = nil,
        strokeColor: Color = RiseColors.borderSubtle.opacity(0.7),
        strokeWidth: CGFloat = 1
    ) -> some View {
        self.modifier(
            RiseLiquidGlassModifier(
                cornerRadius: cornerRadius,
                tintColor: tintColor,
                strokeColor: strokeColor,
                strokeWidth: strokeWidth
            )
        )
    }
}
