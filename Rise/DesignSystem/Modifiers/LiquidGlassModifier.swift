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
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public var cornerRadius: CGFloat
    public var tintColor: Color?
    public var strokeColor: Color
    public var strokeWidth: CGFloat

    public init(
        cornerRadius: CGFloat = RiseRadius.large,
        tintColor: Color? = nil,
        strokeColor: Color = RiseColors.borderHairline,
        strokeWidth: CGFloat = 1
    ) {
        self.cornerRadius = cornerRadius
        self.tintColor = tintColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background {
                ZStack {
                    if reduceTransparency {
                        shape.fill(RiseColors.surfacePrimary)
                    } else {
                        shape.fill(.ultraThinMaterial)
                    }

                    if let tintColor {
                        shape.fill(tintColor.opacity(reduceTransparency ? 0.18 : 0.12))
                    }
                }
            }
            .overlay {
                shape.stroke(strokeColor, lineWidth: strokeWidth)
            }
    }
}

/// Dense dark-purple glass used by Home / Discover content cards.
public struct RiseRichGlassModifier: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public var cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = RiseRadius.card) {
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background {
                ZStack {
                    shape
                        .fill(
                            reduceTransparency
                                ? RiseColors.surfacePrimary
                                : RiseColors.surfaceField.opacity(0.88)
                        )
                    if !reduceTransparency {
                        shape.fill(Color.white.opacity(0.05))
                        shape
                            .fill(
                                LinearGradient(
                                    colors: [
                                        RiseColors.accentPrimary.opacity(0.16),
                                        RiseColors.surfaceField.opacity(0.08),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .overlay {
                shape
                    .stroke(
                        LinearGradient(
                            colors: [
                                RiseColors.accentPrimary.opacity(0.45),
                                RiseColors.borderSubtle.opacity(0.80),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .clipShape(shape)
    }
}

public extension View {
    /// Applies the standard Rise native Liquid Glass styling to the view.
    func riseGlass(
        cornerRadius: CGFloat = RiseRadius.large,
        tintColor: Color? = nil,
        strokeColor: Color = RiseColors.borderHairline,
        strokeWidth: CGFloat = 1
    ) -> some View {
        modifier(
            RiseLiquidGlassModifier(
                cornerRadius: cornerRadius,
                tintColor: tintColor,
                strokeColor: strokeColor,
                strokeWidth: strokeWidth
            )
        )
    }

    /// Dense dark-purple glass used by Home / Discover content cards.
    /// Avoids heavy Material sampling so the surface stays uniform across tabs.
    /// Honors Reduce Transparency with an opaque surface fallback.
    func riseRichGlass(cornerRadius: CGFloat = RiseRadius.card) -> some View {
        modifier(RiseRichGlassModifier(cornerRadius: cornerRadius))
    }

    /// Shared accent → subtle card outline used by image heroes that can't take full `riseRichGlass`.
    func riseCardStroke(cornerRadius: CGFloat = RiseRadius.card) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        return overlay {
            shape
                .stroke(
                    LinearGradient(
                        colors: [
                            RiseColors.accentPrimary.opacity(0.45),
                            RiseColors.borderSubtle.opacity(0.80),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .clipShape(shape)
    }

    /// Shared onboarding/home category tile glass — dark fill, material, optional
    /// selection tint, and top-leading specular shine.
    func riseCategoryGlass(
        cornerRadius: CGFloat = RiseRadius.large,
        isSelected: Bool = false,
        alwaysShowSpecular: Bool = false
    ) -> some View {
        modifier(
            RiseCategoryGlassModifier(
                cornerRadius: cornerRadius,
                isSelected: isSelected,
                alwaysShowSpecular: alwaysShowSpecular
            )
        )
    }
}

/// Rich category / action tile glass used by onboarding pickers and Home quick actions.
public struct RiseCategoryGlassModifier: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor

    public var cornerRadius: CGFloat
    public var isSelected: Bool
    public var alwaysShowSpecular: Bool

    public init(
        cornerRadius: CGFloat = RiseRadius.large,
        isSelected: Bool = false,
        alwaysShowSpecular: Bool = false
    ) {
        self.cornerRadius = cornerRadius
        self.isSelected = isSelected
        self.alwaysShowSpecular = alwaysShowSpecular
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    private var showsSpecular: Bool {
        !reduceTransparency && (isSelected || alwaysShowSpecular)
    }

    public func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    shape
                        .fill(
                            reduceTransparency
                                ? RiseColors.surfacePrimary
                                : RiseColors.surfaceField.opacity(0.82)
                        )
                    if !reduceTransparency {
                        shape
                            .fill(.ultraThinMaterial)
                            .opacity(0.35)
                    }
                    if isSelected {
                        shape
                            .fill(RiseColors.accentPrimary.opacity(reduceTransparency ? 0.32 : 0.22))
                    } else if alwaysShowSpecular {
                        shape
                            .fill(RiseColors.accentPrimary.opacity(0.10))
                    }
                }
            }
            .overlay {
                ZStack {
                    shape
                        .stroke(
                            isSelected
                                ? RiseColors.accentPrimary
                                : RiseColors.borderHairline,
                            lineWidth: isSelected ? (differentiateWithoutColor ? 2.0 : 1.5) : 1.0
                        )

                    if showsSpecular {
                        shape
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(isSelected ? 0.85 : 0.55),
                                        RiseColors.accentPrimary.opacity(isSelected ? 0.60 : 0.35),
                                        Color.clear,
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 1.2 : 1.1
                            )
                    }
                }
            }
            .clipShape(shape)
            .riseShadow(isSelected ? RiseShadows.accentGlow : RiseShadows.elevationLow)
    }
}
