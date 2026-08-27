//
//  IntentionCompleteView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Confirmation screen after setting a daily intention.
public struct IntentionCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    public init() {}

    public var body: some View {
        ZStack {
            RiseScreenBackground(imageMaxHeight: 360, bottomScrimOpacity: 0.95)

            VStack(spacing: RiseSpacing.lg) {
                RiseFeatureChrome(onBack: { dismiss() })

                Spacer()

                Image("onboarding_icon_target")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .riseSuccessBurst()

                Text("Intention set!")
                    .font(RiseTypography.display)
                    .foregroundStyle(RiseColors.textPrimary)
                    .riseAppear(delay: 0.08)

                Text("You’re choosing direction today.\nCome back tonight and reflect on how it went.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .riseAppear(delay: 0.14)

                VStack(alignment: .leading, spacing: 10) {
                    Text("TODAY’S INTENTION")
                        .font(RiseTypography.microBold)
                        .foregroundStyle(RiseColors.textSecondary)
                    Text(UserProfileStore.shared.todayIntention ?? "Stay focused and finish what I start.")
                        .font(RiseTypography.headline)
                        .foregroundStyle(RiseColors.textPrimary)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
                .riseAppear(delay: 0.20)

                Spacer()

                RisePrimaryButton("Back to Home", iconName: "arrow.right", style: .gold) {
                    router.popToRoot(for: appState.selectedTab)
                    appState.selectedTab = .home
                }

                Button("Set another intention") {
                    dismiss()
                }
                .font(RiseTypography.calloutSemibold)
                .foregroundStyle(RiseColors.accentPrimary)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, RiseSpacing.md)
        }
        .navigationBarHidden(true)
    }
}

#Preview { IntentionCompleteView().environment(AppRouter()).environment(AppState()) }
