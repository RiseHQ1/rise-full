//
//  OnboardingMotivationStyleView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

// Onboarding Step 4: "How should Rise motivate you?" motivation style selection screen.

public struct OnboardingMotivationStyleView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public var body: some View {
        let onboardingState = appState.onboardingState

        ZStack(alignment: .top) {
            // MARK: - 1. Upper Hero Background Image (Full-bleed into status bar)

            VStack(spacing: 0) {
                GeometryReader { geo in
                    Image("onboarding_motivation_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 310, alignment: .topTrailing)
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
                .frame(height: 310)

                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)

            // MARK: - 2. Onboarding Content Layer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section (Positioned comfortably below high top bar)
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()

                            Text("How should Rise")
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.textPrimary)

                            HStack(spacing: 0) {
                                Text("motivate ")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("you?")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }

                            Text("Choose the tone that best empowers\nyour daily progress.")
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
                    VStack(alignment: .leading, spacing: 12) {
                        // 5 Horizontal Motivation Cards
                        VStack(spacing: 10) {
                            ForEach(OnboardingMotivationOption.allCases) { option in
                                MotivationCard(
                                    option: option,
                                    isSelected: onboardingState.selectedMotivationStyle == option
                                ) {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        onboardingState.selectedMotivationStyle = option
                                        onboardingState.validationErrorMessage = nil
                                    }
                                }
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

                        // Primary CTA Button ("Continue ->") - Triggers Validation
                        RisePrimaryButton("Continue", iconName: "arrow.right", style: .gold) {
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.advanceFromStep3()
                            }
                        }
                        .disabled(onboardingState.selectedMotivationStyle == nil)
                        .padding(.top, 4)

                        // Footer Lock Note
                        HStack(spacing: 5) {
                            Spacer()
                            Image(systemName: "lock.fill")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.textMuted)
                            Text("You can change this anytime in settings.")
                                .font(RiseTypography.micro)
                                .foregroundStyle(RiseColors.textMuted)
                            Spacer()
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

// MARK: - Motivation Options Domain Definition

public enum OnboardingMotivationOption: String, CaseIterable, Identifiable {
    case gentle
    case direct
    case toughLove
    case positive
    case calm

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .gentle: return "Gentle"
        case .direct: return "Direct"
        case .toughLove: return "Tough Love"
        case .positive: return "Positive"
        case .calm: return "Calm"
        }
    }

    public var description: String {
        switch self {
        case .gentle: return "Soft nudges and encouraging reminders to keep going."
        case .direct: return "Clear, actionable feedback without fluff."
        case .toughLove: return "High standards and firm push to reach your goals."
        case .positive: return "High-energy praise and optimistic reinforcement."
        case .calm: return "Mindful reflection and peaceful grounding words."
        }
    }

    public var iconName: String {
        switch self {
        case .gentle: return "onboarding_icon_motivation"
        case .direct: return "onboarding_icon_lightning"
        case .toughLove: return "onboarding_icon_fire_red"
        case .positive: return "onboarding_icon_smiley"
        case .calm: return "onboarding_icon_calm"
        }
    }
}

// MARK: - Motivation Horizontal Card Component

private struct MotivationCard: View {
    let option: OnboardingMotivationOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // 3D Icon Asset (Matching 40x40 sizing)
                Image(option.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(option.title)
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.textPrimary)

                    Text(option.description)
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                // Selection Badge Circle
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(RiseColors.accentSecondary)
                            .frame(width: 20, height: 20)

                        Image(systemName: "checkmark")
                            .font(RiseTypography.microBold)
                            .foregroundStyle(RiseColors.textOnGold)
                    } else {
                        Circle()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .riseCategoryGlass(cornerRadius: 16, isSelected: isSelected)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(option.title), \(isSelected ? "selected" : "not selected")")
    }
}

#Preview("OnboardingMotivationStyleView") {
    OnboardingMotivationStyleView()
        .environment(PreviewContainer.makeAppState())
}
