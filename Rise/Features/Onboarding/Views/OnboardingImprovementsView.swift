//
//  OnboardingImprovementsView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Onboarding Step 3: "What do you want to improve?" goal selection screen.
///
/// Faithfully reproduces the official reference design featuring:
/// - Hero upper background artwork extending into status bar
/// - Left-aligned header text with gold highlight
/// - Glass pill badge: "✨ Select 1–4 options"
/// - 2-column x 4-row grid (8 options matching official reference)
/// - 1-4 selection limit validation & subtle inline error warning pill
/// - Zero "I'll choose later" bypass.
public struct OnboardingImprovementsView: View {
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
            
            // MARK: - 2. Content Layer
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section (Positioned comfortably below high top bar)
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()
                            
                            Text("What do you")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            
                            HStack(spacing: 0) {
                                Text("want to ")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("improve?")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                            
                            Text("Pick a few things you’d like to\nwork on. We’ll help you get there.")
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
                        // Glass Pill Badge: "✨ Select 1–4 options"
                        HStack(spacing: 6) {
                            Text("✨")
                                .font(.system(size: 11))
                            Text("Select 1–4 options")
                                .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(hex: "#FFD868"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(hex: "#100C24").opacity(0.82))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color(hex: "#FFD868").opacity(0.35), lineWidth: 1)
                        )
                        .padding(.bottom, 2)
                        
                        // 2x4 Category Grid (8 Official Reference Options)
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10)
                            ],
                            spacing: 10
                        ) {
                            ForEach(OnboardingImprovement.allCases) { item in
                                ImprovementCard(
                                    item: item,
                                    isSelected: onboardingState.selectedImprovements.contains(item)
                                ) {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        onboardingState.toggleImprovement(item)
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
                                onboardingState.advanceFromStep2()
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
                            .opacity((onboardingState.selectedImprovements.isEmpty || onboardingState.selectedImprovements.count > 4) ? 0.60 : 1.0)
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

// MARK: - Domain Improvement Options Definition (Matching Official Reference Screen)
public enum OnboardingImprovement: String, CaseIterable, Identifiable {
    case stayConsistent
    case focusBetter
    case buildConfidence
    case buildDiscipline
    case buildBetterHabits
    case feelMorePositive
    case findMoreBalance
    case achieveMyGoals
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .stayConsistent: return "Stay consistent"
        case .focusBetter: return "Focus better"
        case .buildConfidence: return "Build confidence"
        case .buildDiscipline: return "Build discipline"
        case .buildBetterHabits: return "Build better habits"
        case .feelMorePositive: return "Feel more positive"
        case .findMoreBalance: return "Find more balance"
        case .achieveMyGoals: return "Achieve my goals"
        }
    }
    
    public var description: String {
        switch self {
        case .stayConsistent: return "Follow through even when\nmotivation fades."
        case .focusBetter: return "Spend less time\ndistracted."
        case .buildConfidence: return "Believe in yourself and\nyour abilities."
        case .buildDiscipline: return "Do what needs\nto be done."
        case .buildBetterHabits: return "Make positive\nchanges stick."
        case .feelMorePositive: return "Approach your days\nwith a better mindset."
        case .findMoreBalance: return "Make space for yourself\nand what matters."
        case .achieveMyGoals: return "Turn intentions\ninto action."
        }
    }
    
    public var iconName: String {
        switch self {
        case .stayConsistent: return "onboarding_icon_motivation"
        case .focusBetter: return "onboarding_icon_brain"
        case .buildConfidence: return "onboarding_icon_muscle"
        case .buildDiscipline: return "onboarding_icon_fire"
        case .buildBetterHabits: return "onboarding_icon_sprout_soil"
        case .feelMorePositive: return "onboarding_icon_sun"
        case .findMoreBalance: return "onboarding_icon_relationships"
        case .achieveMyGoals: return "onboarding_icon_growth"
        }
    }
}

// MARK: - Improvement Card Component
private struct ImprovementCard: View {
    let item: OnboardingImprovement
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

#Preview("OnboardingImprovementsView") {
    OnboardingImprovementsView()
        .environment(PreviewContainer.makeAppState())
}
