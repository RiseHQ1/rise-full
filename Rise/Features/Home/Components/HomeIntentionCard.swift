//
//  HomeIntentionCard.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Glass card for capturing or displaying today's intention with glass input and gold CTA.
public struct HomeIntentionCard: View {
    @Binding public var intentionText: String
    public var activeIntention: String?
    public let onSetIntention: () -> Void
    public var onEditIntention: (() -> Void)?

    public init(
        intentionText: Binding<String>,
        activeIntention: String? = nil,
        onSetIntention: @escaping () -> Void,
        onEditIntention: (() -> Void)? = nil
    ) {
        _intentionText = intentionText
        self.activeIntention = activeIntention
        self.onSetIntention = onSetIntention
        self.onEditIntention = onEditIntention
    }

    public var body: some View {
        let canSetIntention = !intentionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isSet = !(activeIntention?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        RiseContentCard {
            VStack(alignment: .leading, spacing: RiseSpacing.sm) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(RiseColors.accentPrimary.opacity(0.35))
                            .frame(width: 28, height: 28)

                        Image("onboarding_icon_target")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }

                    Text(RiseL10n.tr("home.intention.header"))
                        .font(RiseTypography.microSemibold)
                        .tracking(0.6)
                        .foregroundStyle(RiseColors.textSecondary)

                    Spacer()

                    if isSet {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(RiseTypography.captionSemibold)
                                .foregroundStyle(RiseColors.success)
                            Text("Active")
                                .font(RiseTypography.microBold)
                                .foregroundStyle(RiseColors.success)
                        }
                    }
                }

                if let active = activeIntention, !active.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(active)
                            .font(RiseTypography.calloutSemibold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .lineSpacing(3)

                        Button(action: {
                            onEditIntention?()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "pencil")
                                    .font(RiseTypography.captionSemibold)
                                Text(RiseL10n.tr("home.intention.update"))
                                    .font(RiseTypography.captionSemibold)
                            }
                            .foregroundStyle(RiseColors.accentPrimary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.97)),
                        removal: .opacity
                    ))
                } else {
                    VStack(alignment: .leading, spacing: RiseSpacing.sm) {
                        Text(RiseL10n.tr("home.intention.prompt"))
                            .font(RiseTypography.subheadline)
                            .foregroundStyle(RiseColors.textPrimary)

                        RiseTextField(
                            placeholder: "Write your intention...",
                            text: $intentionText,
                            textInputAutocapitalization: .sentences
                        )

                        RisePrimaryButton(
                            RiseL10n.tr("home.intention.set"),
                            iconName: "arrow.right",
                            style: .gold,
                            action: onSetIntention
                        )
                        .disabled(!canSetIntention)
                    }
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.97)),
                        removal: .opacity
                    ))
                }
            }
            .animation(RiseAnimations.modalSpring, value: isSet)
        }
    }
}

#Preview("HomeIntentionCard") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        HomeIntentionCard(intentionText: .constant(""), onSetIntention: {})
            .padding(RiseSpacing.md)
    }
}
