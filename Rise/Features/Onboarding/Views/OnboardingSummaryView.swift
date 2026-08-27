//
//  OnboardingSummaryView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

// Final Onboarding Step: "Make Rise yours. ✨" personalization summary screen.

public struct OnboardingSummaryView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public var body: some View {
        let onboardingState = appState.onboardingState

        ZStack(alignment: .top) {
            // MARK: - 1. Upper Hero Background Image (Full-bleed into status bar)

            VStack(spacing: 0) {
                GeometryReader { geo in
                    Image("onboarding_summary_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 300, alignment: .topTrailing)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .clear, location: 0.55),
                                    .init(color: Color(hex: "#070611").opacity(0.45), location: 0.82),
                                    .init(color: RiseColors.backgroundPrimary, location: 1.0),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
                .frame(height: 300)

                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)

            // MARK: - 2. Content Layer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section (Positioned comfortably below high top bar)
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()

                            Text("Make Rise")
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.textPrimary)

                            HStack(spacing: 4) {
                                Text("yours. ✨")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }

                            Text("Just a few details to personalize\nyour experience.")
                                .font(RiseTypography.footnote)
                                .foregroundStyle(RiseColors.textSecondary)
                                .lineSpacing(2.5)
                                .padding(.top, 2)
                        }
                        .frame(maxWidth: geo.size.width * 0.58, alignment: .leading)
                        .padding(.horizontal, RiseSpacing.lg)
                        .padding(.bottom, 14)
                    }
                    .frame(height: 250)

                    // Main Content Area
                    VStack(alignment: .leading, spacing: 14) {
                        // MARK: - Glass Container 2: Rise Moments (Time Pickers)

                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Choose your Rise moments")
                                    .font(RiseTypography.calloutBold)
                                    .foregroundStyle(RiseColors.textPrimary)

                                Text("We’ll remind you at these times.")
                                    .font(RiseTypography.micro)
                                    .foregroundStyle(RiseColors.textSecondary)
                            }

                            VStack(spacing: 8) {
                                @Bindable var state = onboardingState

                                // Morning Boost Row
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_morning")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Morning Boost")
                                            .font(RiseTypography.footnoteBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("Start your day with motivation.")
                                            .font(RiseTypography.micro)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer(minLength: 0)

                                    DatePicker("", selection: $state.morningTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceInset.opacity(0.6))
                                )

                                // Evening Reflection Row
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_moon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Evening Reflection")
                                            .font(RiseTypography.footnoteBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("End your day with reflection.")
                                            .font(RiseTypography.micro)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer(minLength: 0)

                                    DatePicker("", selection: $state.eveningTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceInset.opacity(0.6))
                                )
                            }
                        }
                        .padding(14)
                        .background {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(RiseColors.surfaceField.opacity(0.82))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(RiseColors.borderHairline, lineWidth: 1)
                                }
                        }

                        // MARK: - Glass Container 3: Notification Preferences (Toggles)

                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Notification preferences")
                                    .font(RiseTypography.calloutBold)
                                    .foregroundStyle(RiseColors.textPrimary)

                                Text("You can change these anytime.")
                                    .font(RiseTypography.micro)
                                    .foregroundStyle(RiseColors.textSecondary)
                            }

                            VStack(spacing: 8) {
                                @Bindable var state = onboardingState

                                // Row 1: Daily Motivation
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_sun")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Daily motivation")
                                            .font(RiseTypography.footnoteBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("Get your daily boost.")
                                            .font(RiseTypography.micro)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer(minLength: 0)

                                    Toggle("", isOn: $state.isDailyMotivationEnabled)
                                        .labelsHidden()
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceInset.opacity(0.6))
                                )

                                // Row 2: Evening Reflection
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_moon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Evening reflection")
                                            .font(RiseTypography.footnoteBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("A reminder to reflect on your day.")
                                            .font(RiseTypography.micro)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer(minLength: 0)

                                    Toggle("", isOn: $state.isEveningReflectionEnabled)
                                        .labelsHidden()
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceInset.opacity(0.6))
                                )

                                // Row 3: Intention Reminder
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_target")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Intention reminder")
                                            .font(RiseTypography.footnoteBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("A gentle nudge about your intention.")
                                            .font(RiseTypography.micro)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer(minLength: 0)

                                    Toggle("", isOn: $state.isIntentionReminderEnabled)
                                        .labelsHidden()
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceInset.opacity(0.6))
                                )
                            }
                        }
                        .padding(14)
                        .background {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(RiseColors.surfaceField.opacity(0.82))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(RiseColors.borderHairline, lineWidth: 1)
                                }
                        }

                        // Inline Validation Warning Banner (Subtle & Polished)
                        if let errorMessage = onboardingState.validationErrorMessage {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(RiseTypography.captionSemibold)
                                    .foregroundStyle(RiseColors.accentSecondary)
                                Text(errorMessage)
                                    .font(RiseTypography.caption)
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RiseColors.accentSecondary.opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(RiseColors.accentSecondary.opacity(0.35), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .padding(.top, 2)
                        }

                        // MARK: - Primary CTA Button ("Let's Rise ->")

                        RisePrimaryButton(
                            onboardingState.isCompletingOnboarding ? "Entering Rise..." : "Let’s Rise",
                            iconName: onboardingState.isCompletingOnboarding ? nil : "arrow.right",
                            isLoading: onboardingState.isCompletingOnboarding,
                            style: .gold
                        ) {
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.completeOnboarding(appState: appState)
                            }
                        }
                        .padding(.top, 2)
                        .disabled(onboardingState.isCompletingOnboarding)

                        // Secondary Action Button ("I'll set this up later ›")
                        Button(action: {
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.completeOnboarding(appState: appState)
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("I’ll set this up later")
                                    .font(RiseTypography.subheadline)
                                    .foregroundStyle(RiseColors.textSecondary)

                                Image(systemName: "chevron.right")
                                    .font(RiseTypography.captionSemibold)
                                    .foregroundStyle(RiseColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                        }
                        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                        .disabled(onboardingState.isCompletingOnboarding)

                        // Footer Lock & Privacy Note
                        HStack(spacing: 4) {
                            Spacer()
                            Image(systemName: "lock.fill")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.textMuted)

                            Text("Your data is private and secure. Read our ")
                                .font(RiseTypography.micro)
                                .foregroundStyle(RiseColors.textMuted)

                            Text("Privacy Policy.")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.accentSecondary)
                            Spacer()
                        }
                        .padding(.top, 2)
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview("OnboardingSummaryView") {
    OnboardingSummaryView()
        .environment(PreviewContainer.makeAppState())
}
