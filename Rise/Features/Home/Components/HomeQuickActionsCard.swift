//
//  HomeQuickActionsCard.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Quick actions row with five compact glass tiles and header link.
public struct HomeQuickActionsCard: View {
    public let onNeedSomething: () -> Void
    public let onSelect: (HomeState.QuickAction) -> Void

    public init(
        onNeedSomething: @escaping () -> Void,
        onSelect: @escaping (HomeState.QuickAction) -> Void
    ) {
        self.onNeedSomething = onNeedSomething
        self.onSelect = onSelect
    }

    public var body: some View {
        RiseContentCard(horizontalPadding: 14, verticalPadding: 16) {
            VStack(alignment: .leading, spacing: RiseSpacing.sm) {
                HStack {
                    Text(RiseL10n.tr("home.quickActions.title").uppercased())
                        .font(RiseTypography.microSemibold)
                        .tracking(0.6)
                        .foregroundStyle(RiseColors.textSecondary)

                    Spacer(minLength: 0)

                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        onNeedSomething()
                    }) {
                        HStack(spacing: 4) {
                            Text(RiseL10n.tr("home.needSomething"))
                                .font(RiseTypography.captionSemibold)
                            Image(systemName: "arrow.right")
                                .font(RiseTypography.microBold)
                                .accessibilityHidden(true)
                        }
                        .foregroundStyle(RiseColors.accentSecondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(RiseL10n.tr("home.needSomething"))
                    .riseMinimumHitTarget()
                }

                HStack(alignment: .top, spacing: 6) {
                    ForEach(HomeState.QuickAction.allCases) { action in
                        quickActionButton(action)
                    }
                }
            }
        }
    }

    private func quickActionButton(_ action: HomeState.QuickAction) -> some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            onSelect(action)
        } label: {
            VStack(spacing: 8) {
                Image(action.iconAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .accessibilityHidden(true)

                Text(action.title)
                    .font(RiseTypography.microBold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 92)
            .riseCategoryGlass(cornerRadius: 16, alwaysShowSpecular: true)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel(action.title.replacingOccurrences(of: "\n", with: " "))
        .riseMinimumHitTarget()
    }
}

#Preview("HomeQuickActionsCard") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        HomeQuickActionsCard(onNeedSomething: {}, onSelect: { _ in })
            .padding(RiseSpacing.md)
    }
}
