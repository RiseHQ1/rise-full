//
//  OnboardingRoutineSetupView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

// Onboarding Step 5: "When do you need Rise most?" routine time & duration preference selection screen.

public struct OnboardingRoutineSetupView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public var body: some View {
        let onboardingState = appState.onboardingState

        ZStack(alignment: .top) {
            // MARK: - 1. Upper Hero Background Image (Full-bleed into status bar)

            VStack(spacing: 0) {
                GeometryReader { geo in
                    Image("onboarding_focus_bg")
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

            // MARK: - 2. Onboarding Content Layer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section (Positioned comfortably below high top bar)
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()

                            Text("When do you")
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.textPrimary)

                            HStack(spacing: 0) {
                                Text("need ")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("Rise most?")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }

                            Text("We'll show up at the right times\nto support you.")
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
                        // Section 1: 2x2 Time of Day Category Grid
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10),
                            ],
                            spacing: 10
                        ) {
                            ForEach(TimeOfDayPreference.allCases) { item in
                                TimeOfDayCard(
                                    item: item,
                                    isSelected: onboardingState.selectedTimeOfDay == item
                                ) {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        onboardingState.selectedTimeOfDay = item
                                        onboardingState.validationErrorMessage = nil
                                    }
                                }
                            }
                        }

                        // Section Divider with Central Clock Icon & Centered Label Below
                        VStack(spacing: 8) {
                            // Line 1: Horizontal Hairline Divider with Centered Clock Circle Badge
                            HStack(spacing: 12) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(height: 1)

                                Image(systemName: "clock")
                                    .font(RiseTypography.captionBold)
                                    .foregroundStyle(RiseColors.accentPrimary)

                                Rectangle()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(height: 1)
                            }

                            // Line 2: Centered Question Text Below
                            Text("How much time would you like to focus on yourself?")
                                .font(RiseTypography.footnoteMedium)
                                .foregroundStyle(RiseColors.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 4)

                        // Section 2: 4-Column Horizontal Duration Chips
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8),
                            ],
                            spacing: 8
                        ) {
                            ForEach(FocusDurationPreference.allCases) { item in
                                DurationChipCard(
                                    item: item,
                                    isSelected: onboardingState.selectedDuration == item
                                ) {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        onboardingState.selectedDuration = item
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
                                onboardingState.advanceFromStep4()
                            }
                        }
                        .disabled(onboardingState.selectedTimeOfDay == nil || onboardingState.selectedDuration == nil)
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

// MARK: - Time of Day Domain Definition for Step 5

public enum TimeOfDayPreference: String, CaseIterable, Identifiable {
    case morning
    case duringDay
    case evening
    case allDay

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .morning: return "Morning"
        case .duringDay: return "During the day"
        case .evening: return "Evening"
        case .allDay: return "All day"
        }
    }

    public var description: String {
        switch self {
        case .morning: return "Start the day\nmotivated and focused."
        case .duringDay: return "Keep my momentum\nand stay on track."
        case .evening: return "Reflect on my day\nand reset."
        case .allDay: return "Give me little boosts\nthroughout the day."
        }
    }

    public var iconName: String {
        switch self {
        case .morning: return "onboarding_icon_morning"
        case .duringDay: return "onboarding_icon_sun"
        case .evening: return "onboarding_icon_moon"
        case .allDay: return "onboarding_icon_refresh"
        }
    }
}

// MARK: - Focus Duration Domain Definition for Step 5

public enum FocusDurationPreference: String, CaseIterable, Identifiable {
    case fiveMinutes
    case tenMinutes
    case fifteenMinutes
    case whenever

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .fiveMinutes: return "5 min"
        case .tenMinutes: return "10 min"
        case .fifteenMinutes: return "15 min"
        case .whenever: return "Whenever"
        }
    }

    public var subtitle: String {
        switch self {
        case .fiveMinutes, .tenMinutes, .fifteenMinutes: return "a day"
        case .whenever: return "I need it"
        }
    }

    public var minutes: Int {
        switch self {
        case .fiveMinutes: return 5
        case .tenMinutes: return 10
        case .fifteenMinutes: return 15
        case .whenever: return 25
        }
    }

    public var systemIcon: String {
        switch self {
        case .whenever: return "infinity"
        default: return "clock"
        }
    }
}

// MARK: - Time of Day Card Component

private struct TimeOfDayCard: View {
    let item: TimeOfDayPreference
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                // Top Row: Icon Container + Selection Badge Circle
                HStack(alignment: .top) {
                    Image(item.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .accessibilityHidden(true)

                    Spacer(minLength: 0)

                    // Selection Badge Circle
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(RiseColors.accentSecondary)
                                .frame(width: 18, height: 18)

                            Image(systemName: "checkmark")
                                .font(RiseTypography.microBold)
                                .foregroundStyle(RiseColors.textOnGold)
                        } else {
                            Circle()
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                                .frame(width: 18, height: 18)
                        }
                    }
                }

                // Title
                Text(item.title)
                    .font(RiseTypography.footnoteBold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineLimit(1)
                    .padding(.top, 2)

                // Description
                Text(item.description)
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineSpacing(1.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .riseCategoryGlass(cornerRadius: 16, isSelected: isSelected)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(item.title), \(isSelected ? "selected" : "not selected")")
    }
}

// MARK: - Duration Chip Card Component (Standalone Icons & Unified Selection)

private struct DurationChipCard: View {
    let item: FocusDurationPreference
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 3) {
                // Top Row: Standalone Icon + Selection Check Badge
                HStack(alignment: .top) {
                    Image(systemName: item.systemIcon)
                        .font(RiseTypography.headlineBold)
                        .foregroundStyle(RiseColors.accentPrimary)

                    Spacer(minLength: 0)

                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(RiseColors.accentSecondary)
                                .frame(width: 16, height: 16)

                            Image(systemName: "checkmark")
                                .font(RiseTypography.microBold)
                                .foregroundStyle(RiseColors.textOnGold)
                        } else {
                            Circle()
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                                .frame(width: 16, height: 16)
                        }
                    }
                }

                // Title
                Text(item.title)
                    .font(RiseTypography.footnoteBold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineLimit(1)
                    .padding(.top, 2)

                // Subtitle
                Text(item.subtitle)
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineLimit(1)
            }
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: 84, alignment: .topLeading)
            .riseCategoryGlass(cornerRadius: 14, isSelected: isSelected)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(item.title) \(item.subtitle), \(isSelected ? "selected" : "not selected")")
    }
}

#Preview("OnboardingRoutineSetupView") {
    OnboardingRoutineSetupView()
        .environment(PreviewContainer.makeAppState())
}
