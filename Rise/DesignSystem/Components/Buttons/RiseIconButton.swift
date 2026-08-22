//
//  RiseIconButton.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Style variant for circular icon buttons.
public enum RiseIconButtonStyle {
    case surface
    case glass
}

/// Circular or rounded icon button with accessible hit target, rich Liquid Glass background, and haptic feedback.
public struct RiseIconButton: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public let iconName: String
    public let accessibilityLabel: String
    public var style: RiseIconButtonStyle
    public var size: CGFloat
    public let action: () -> Void
    
    public init(
        iconName: String,
        accessibilityLabel: String,
        style: RiseIconButtonStyle = .glass,
        size: CGFloat = 44,
        action: @escaping () -> Void
    ) {
        self.iconName = iconName
        self.accessibilityLabel = accessibilityLabel
        self.style = style
        self.size = max(size, 44) // Guarantee minimum 44x44pt accessibility target
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Image(systemName: iconName)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(RiseColors.textPrimary)
                .frame(width: size, height: size)
                .background {
                    if style == .glass {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#100C24").opacity(0.55))
                            Circle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.60)
                            Circle()
                                .fill(RiseColors.accentPrimary.opacity(0.12))
                        }
                    } else {
                        Circle()
                            .fill(RiseColors.surfacePrimary)
                    }
                }
                .overlay {
                    Circle()
                        .stroke(
                            style == .glass
                                ? LinearGradient(
                                    colors: [
                                        RiseColors.accentPrimary.opacity(0.40),
                                        RiseColors.borderSubtle.opacity(0.60)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(colors: [RiseColors.borderSubtle], startPoint: .top, endPoint: .bottom),
                            lineWidth: 1
                        )
                }
                .clipShape(Circle())
                .riseShadow(style == .glass ? RiseShadows.elevationMedium : RiseShadows.elevationLow)
        }
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview("RiseIconButton - Variants") {
    HStack(spacing: RiseSpacing.lg) {
        RiseIconButton(iconName: "bookmark", accessibilityLabel: "Save Item", style: .surface) {}
        RiseIconButton(iconName: "heart.fill", accessibilityLabel: "Favorite", style: .surface) {}
        RiseIconButton(iconName: "chevron.left", accessibilityLabel: "Back", style: .glass) {}
        RiseIconButton(iconName: "gearshape", accessibilityLabel: "Settings", style: .glass) {}
    }
    .padding(RiseSpacing.xl)
    .background(RiseColors.backgroundPrimary)
}
