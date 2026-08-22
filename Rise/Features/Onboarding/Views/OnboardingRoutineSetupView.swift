//
//  OnboardingRoutineSetupView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Onboarding Step 5: "When do you need Rise most?" routine time & duration preference selection screen.
///
/// Features a full-bleed upper hero artwork, left-constrained header text, 2x2 time-of-day category grid with 44x44 3D icons,
/// section divider with central clock badge & label, 4-column duration selection chips with standalone icons,
/// mandatory validation (both time of day & duration required), inline warning message banner, and zero "I'll choose later" bypass.
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
                                colors: [
                                    Color.clear,
                                    Color(hex: "#070611").opacity(0.35),
                                    RiseColors.backgroundPrimary
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
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            
                            HStack(spacing: 0) {
                                Text("need ")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("Rise most?")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                            
                            Text("We'll show up at the right times\nto support you.")
                                .font(.system(size: 13, weight: .regular))
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
                                GridItem(.flexible(), spacing: 10)
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
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(RiseColors.accentPrimary)
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(height: 1)
                            }
                            
                            // Line 2: Centered Question Text Below
                            Text("How much time would you like to focus on yourself?")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
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
                                GridItem(.flexible(), spacing: 8)
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
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#F59E0B"))
                                Text(errorMessage)
                                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color(hex: "#F59E0B"))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#F59E0B").opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color(hex: "#F59E0B").opacity(0.35), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .padding(.top, 2)
                        }
                        
                        // Primary CTA Button ("Continue ->") - Triggers Validation
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.advanceFromStep4()
                            }
                        }) {
                            ZStack {
                                Text("Continue")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(hex: "#090616"))
                                
                                HStack {
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(Color(hex: "#090616"))
                                        .padding(.trailing, 20)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#FFD868"),
                                        Color(hex: "#F59E0B")
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .opacity((onboardingState.selectedTimeOfDay == nil || onboardingState.selectedDuration == nil) ? 0.60 : 1.0)
                            .riseShadow(RiseShadows.goldGlow)
                        }
                        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                        .padding(.top, 4)
                        
                        // Footer Lock Note
                        HStack(spacing: 5) {
                            Spacer()
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(RiseColors.textMuted)
                            Text("You can change this anytime in settings.")
                                .font(.system(size: 11.5, weight: .regular))
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
    
    public var id: String { rawValue }
    
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
    
    public var id: String { rawValue }
    
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
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color(hex: "#090616"))
                        } else {
                            Circle()
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                
                // Title
                Text(item.title)
                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineLimit(1)
                    .padding(.top, 2)
                
                // Description
                Text(item.description)
                    .font(.system(size: 10.5, weight: .regular))
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineSpacing(1.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .background {
                ZStack {
                    // Dark Translucent Glass Surface
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(hex: "#100C24").opacity(0.82))
                    
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.35)
                    
                    if isSelected {
                        // Subtle Purple Illumination Tint
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(RiseColors.accentPrimary.opacity(0.22))
                    }
                }
            }
            .overlay {
                ZStack {
                    // Outer Border
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(
                            isSelected
                                ? RiseColors.accentPrimary
                                : RiseColors.borderSubtle.opacity(0.6),
                            lineWidth: isSelected ? 1.5 : 1.0
                        )
                    
                    if isSelected {
                        // Top-Left Specular Shine Streak Highlight
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.85),
                                        RiseColors.accentPrimary.opacity(0.60),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .riseShadow(isSelected ? RiseShadows.accentGlow : RiseShadows.elevationLow)
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
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(RiseColors.accentPrimary)
                    
                    Spacer(minLength: 0)
                    
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(RiseColors.accentSecondary)
                                .frame(width: 16, height: 16)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color(hex: "#090616"))
                        } else {
                            Circle()
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                
                // Title
                Text(item.title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineLimit(1)
                    .padding(.top, 2)
                
                // Subtitle
                Text(item.subtitle)
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineLimit(1)
            }
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: 84, alignment: .topLeading)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(hex: "#100C24").opacity(0.82))
                    
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.35)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(RiseColors.accentPrimary.opacity(0.22))
                    }
                }
            }
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(
                            isSelected
                                ? RiseColors.accentPrimary
                                : RiseColors.borderSubtle.opacity(0.6),
                            lineWidth: isSelected ? 1.5 : 1.0
                        )
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.85),
                                        RiseColors.accentPrimary.opacity(0.60),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .riseShadow(isSelected ? RiseShadows.accentGlow : RiseShadows.elevationLow)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(item.title) \(item.subtitle), \(isSelected ? "selected" : "not selected")")
    }
}

#Preview("OnboardingRoutineSetupView") {
    OnboardingRoutineSetupView()
        .environment(PreviewContainer.makeAppState())
}
