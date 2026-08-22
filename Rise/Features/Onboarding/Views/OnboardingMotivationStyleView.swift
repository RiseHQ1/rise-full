//
//  OnboardingMotivationStyleView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Onboarding Step 4: "How should Rise motivate you?" motivation style selection screen.
///
/// Features a full-bleed upper hero artwork, header text with balanced breathing room,
/// 5 horizontal liquid glass cards with custom 3D icons, single-select validation, inline warning message banner, and zero "I'll choose later" bypass.
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
                    Image("onboarding_focus_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 310, alignment: .topTrailing)
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
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            
                            HStack(spacing: 0) {
                                Text("motivate ")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("you?")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                            
                            Text("Choose the tone that best empowers\nyour daily progress.")
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
                                onboardingState.advanceFromStep3()
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
                            .opacity(onboardingState.selectedMotivationStyle == nil ? 0.60 : 1.0)
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

// MARK: - Motivation Options Domain Definition
public enum OnboardingMotivationOption: String, CaseIterable, Identifiable {
    case gentle
    case direct
    case toughLove
    case positive
    case calm
    
    public var id: String { rawValue }
    
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
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(RiseColors.textPrimary)
                    
                    Text(option.description)
                        .font(.system(size: 11, weight: .regular))
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
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color(hex: "#090616"))
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
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(hex: "#100C24").opacity(0.82))
                    
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.35)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(RiseColors.accentPrimary.opacity(0.22))
                    }
                }
            }
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(
                            isSelected
                                ? RiseColors.accentPrimary
                                : RiseColors.borderSubtle.opacity(0.6),
                            lineWidth: isSelected ? 1.5 : 1.0
                        )
                    
                    if isSelected {
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
        .accessibilityLabel("\(option.title), \(isSelected ? "selected" : "not selected")")
    }
}

#Preview("OnboardingMotivationStyleView") {
    OnboardingMotivationStyleView()
        .environment(PreviewContainer.makeAppState())
}
