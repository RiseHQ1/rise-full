//
//  OnboardingFocusAreasView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Onboarding Step 2: "What brings you here?" category selection screen.
///
/// Features a full-bleed hero artwork extending into the status bar, header text with balanced breathing room,
/// 3x3 category grid, state validation (at least 1 selection required), inline validation error pill, and zero "I'll choose later" bypass.
public struct OnboardingFocusAreasView: View {
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
                            
                            Text("What brings")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            Text("you here?")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.accentSecondary)
                            
                            Text("Choose the areas you want Rise\nto help you with.")
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
                        // 3x3 Category Grid
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ],
                            spacing: 8
                        ) {
                            ForEach(OnboardingCategory.allCases) { category in
                                CategoryCard(
                                    category: category,
                                    isSelected: onboardingState.selectedCategories.contains(category)
                                ) {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if onboardingState.selectedCategories.contains(category) {
                                            onboardingState.selectedCategories.remove(category)
                                        } else {
                                            onboardingState.selectedCategories.insert(category)
                                        }
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
                                onboardingState.advanceFromStep1()
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
                            .opacity(onboardingState.selectedCategories.isEmpty ? 0.60 : 1.0)
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

// MARK: - Domain Category Definition
public enum OnboardingCategory: String, CaseIterable, Identifiable {
    case motivation
    case discipline
    case studying
    case work
    case relationships
    case fitness
    case money
    case personalGrowth
    case stressRelief
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .motivation: return "Motivation"
        case .discipline: return "Discipline"
        case .studying: return "Studying"
        case .work: return "Work"
        case .relationships: return "Relationships"
        case .fitness: return "Fitness"
        case .money: return "Money"
        case .personalGrowth: return "Personal Growth"
        case .stressRelief: return "Stress Relief"
        }
    }
    
    public var description: String {
        switch self {
        case .motivation: return "Stay inspired and\nkeep moving\nforward."
        case .discipline: return "Build habits and\nstay consistent\nevery day."
        case .studying: return "Focus better and\nachieve your\nacademic goals."
        case .work: return "Be productive\nand reach new\nmilestones."
        case .relationships: return "Build stronger\nconnections and\nunderstand others."
        case .fitness: return "Stay active and\ntake care of your\nbody and mind."
        case .money: return "Develop a healthy\nmindset with\nfinances."
        case .personalGrowth: return "Grow into the best\nversion of\nyourself."
        case .stressRelief: return "Find peace and\nreduce stress in\nyour daily life."
        }
    }
    
    public var iconName: String {
        switch self {
        case .motivation: return "onboarding_icon_motivation"
        case .discipline: return "onboarding_icon_discipline"
        case .studying: return "onboarding_icon_studying"
        case .work: return "onboarding_icon_work"
        case .relationships: return "onboarding_icon_relationships"
        case .fitness: return "onboarding_icon_fitness"
        case .money: return "onboarding_icon_money"
        case .personalGrowth: return "onboarding_icon_growth"
        case .stressRelief: return "onboarding_icon_stress"
        }
    }
}

// MARK: - Category Grid Card View Component
private struct CategoryCard: View {
    let category: OnboardingCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                // Top Row: Icon Container + Selection Badge Circle
                HStack(alignment: .top) {
                    Image(category.iconName)
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
                Text(category.title)
                    .font(.system(size: 12.5, weight: .bold, design: .rounded))
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineLimit(1)
                    .padding(.top, 2)
                
                // Description
                Text(category.description)
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineSpacing(1.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: 124, alignment: .topLeading)
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
        .accessibilityLabel("\(category.title), \(isSelected ? "selected" : "not selected")")
    }
}

#Preview("OnboardingFocusAreasView") {
    OnboardingFocusAreasView()
        .environment(PreviewContainer.makeAppState())
}
