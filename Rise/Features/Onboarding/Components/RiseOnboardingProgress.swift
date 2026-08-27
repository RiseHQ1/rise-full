//
//  RiseOnboardingProgress.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Reusable onboarding progress bar component.
///
/// Displays completed steps with a translucent purple checkmark badge,
/// the active step with a warm gold capsule, and future steps with muted glass capsules.
public struct RiseOnboardingProgress: View {
    public let currentStep: Int
    public let totalSteps: Int

    public init(
        currentStep: Int,
        totalSteps: Int = 4
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }

    public var body: some View {
        HStack(spacing: 6) {
            ForEach(1 ... totalSteps, id: \.self) { step in
                if step < currentStep {
                    // MARK: - Completed Step: Purple Glass Circular Checkmark Badge

                    ZStack {
                        Circle()
                            .fill(Color(hex: "#8B5CF6").opacity(0.35))
                            .frame(width: 18, height: 18)

                        Circle()
                            .stroke(Color(hex: "#8B5CF6").opacity(0.60), lineWidth: 1)
                            .frame(width: 18, height: 18)

                        Image(systemName: "checkmark")
                            .font(RiseTypography.microBold)
                            .foregroundStyle(Color.white)
                    }
                } else if step == currentStep {
                    // MARK: - Current Step: Active Gold Capsule

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    RiseColors.accentGold,
                                    RiseColors.accentSecondary,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 28, height: 4)
                } else {
                    // MARK: - Upcoming Step: Muted Glass Capsule

                    Capsule()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 28, height: 4)
                }
            }
        }
    }
}

#Preview("RiseOnboardingProgress - Step Progression") {
    VStack(spacing: 20) {
        RiseOnboardingProgress(currentStep: 1, totalSteps: 4)
        RiseOnboardingProgress(currentStep: 2, totalSteps: 4)
        RiseOnboardingProgress(currentStep: 3, totalSteps: 4)
        RiseOnboardingProgress(currentStep: 4, totalSteps: 4)
    }
    .padding(30)
    .background(RiseColors.backgroundPrimary)
}
