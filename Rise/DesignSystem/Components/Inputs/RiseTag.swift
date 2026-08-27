//
//  RiseTag.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Selectable pill/tag component supporting selected, unselected, and disabled states.
///
/// Designed for focus areas, mood selections, category filters, and content tagging.
public struct RiseTag: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor

    public let title: String
    public let iconName: String?
    public let isSelected: Bool
    public let action: (() -> Void)?

    public init(
        _ title: String,
        iconName: String? = nil,
        isSelected: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.iconName = iconName
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        if action != nil {
            tagButton
                .accessibilityHint(
                    isSelected ? "Selected. Double tap to deselect." : "Double tap to select."
                )
        } else {
            tagButton
        }
    }

    private var tagButton: some View {
        Button(action: {
            if let action {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                action()
            }
        }) {
            HStack(spacing: RiseSpacing.xs) {
                if let iconName {
                    Image(systemName: iconName)
                        .font(RiseTypography.caption)
                }
                Text(title)
                    .font(RiseTypography.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                if isSelected && differentiateWithoutColor {
                    Image(systemName: "checkmark")
                        .font(RiseTypography.microBold)
                        .accessibilityHidden(true)
                }
            }
            .foregroundStyle(textColor)
            .padding(.horizontal, RiseSpacing.md)
            .padding(.vertical, RiseSpacing.sm)
            .frame(minHeight: 32)
            .background(backgroundColor)
            .overlay {
                Capsule()
                    .stroke(borderColor, lineWidth: isSelected && differentiateWithoutColor ? 2 : 1)
            }
            .clipShape(Capsule())
            .riseShadow(isSelected && isEnabled ? RiseShadows.accentGlow : RiseShadows.elevationLow)
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .disabled(action == nil || !isEnabled)
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityIdentifier("rise.tag.\(title.lowercased().replacingOccurrences(of: " ", with: "."))")
    }

    // MARK: - Semantic Color Resolvers

    private var textColor: Color {
        if !isEnabled {
            return RiseColors.textMuted
        }
        return isSelected ? RiseColors.textOnAccent : RiseColors.textSecondary
    }

    private var backgroundColor: Color {
        if !isEnabled {
            return RiseColors.surfacePrimary.opacity(0.5)
        }
        return isSelected ? RiseColors.accentPrimary : RiseColors.surfacePrimary
    }

    private var borderColor: Color {
        if !isEnabled {
            return RiseColors.borderSubtle.opacity(0.4)
        }
        return isSelected ? RiseColors.accentPrimary : RiseColors.borderSubtle
    }
}

#Preview("RiseTag - States") {
    VStack(alignment: .leading, spacing: RiseSpacing.md) {
        HStack(spacing: RiseSpacing.sm) {
            RiseTag("Mindfulness", iconName: "sparkles", isSelected: true) {}
            RiseTag("Clarity", iconName: "sun.max", isSelected: false) {}
            RiseTag("Resilience", iconName: "shield", isSelected: false) {}
        }

        HStack(spacing: RiseSpacing.sm) {
            RiseTag("Disabled Selected", isSelected: true) {}
                .disabled(true)
            RiseTag("Disabled", isSelected: false) {}
                .disabled(true)
        }
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
