//
//  OnboardingWelcomeView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// First onboarding screen faithfully reproducing the approved Rise Welcome reference design.
///
/// Features the full-bleed sunset balcony artwork, top Rise logo branding header,
/// compact 3-column Liquid Glass feature card with 3D icons, warm gold "Let's Get Started" CTA button,
/// and account login link safely positioned above the iPhone home indicator.
public struct OnboardingWelcomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    @State private var isVisible: Bool = false
    
    public init() {}
    
    public var body: some View {
        let onboardingState = appState.onboardingState
        
        ZStack {
            // MARK: - 1. Full-Bleed Sunset Balcony Background Asset
            Image("onboarding_welcome_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            // MARK: - 2. Readability Gradient Overlays
            VStack(spacing: 0) {
                // Top subtle scrim overlay for logo & text legibility
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.55),
                        Color.black.opacity(0.12),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 180)
                
                Spacer()
                
                // Bottom ambient scrim overlay for card & button legibility
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color(hex: "#070611").opacity(0.40),
                        Color(hex: "#070611").opacity(0.92)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 460)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            // MARK: - 3. Content Layer (Structured to match reference composition)
            VStack(spacing: 0) {
                // MARK: - Top Header (Rise Sunrise Logo & Motto)
                VStack(spacing: RiseSpacing.xs) {
                    Image("rise_sunrise_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 170, maxHeight: 66)
                        .accessibilityLabel("Rise Logo")
                    
                    Text("Your daily boost.")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(RiseColors.accentSecondary)
                        .shadow(color: Color.black.opacity(0.35), radius: 4, x: 0, y: 2)
                    
                    Capsule()
                        .fill(RiseColors.accentSecondary)
                        .frame(width: 24, height: 3)
                        .padding(.vertical, 1)
                    
                    Text("Motivation, reflection and progress\n— all in one place.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(RiseColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
                .padding(.top, 50)
                .opacity(isVisible ? 1.0 : 0.0)
                .offset(y: isVisible || reduceMotion ? 0 : 10)
                .animation(reduceMotion ? nil : .easeOut(duration: 0.6).delay(0.15), value: isVisible)
                
                // Flexible spacer preserving middle character view
                Spacer(minLength: 12)
                
                // MARK: - Bottom Group: Compact Feature Card + CTA + Login
                VStack(spacing: 14) {
                    // MARK: - Compact 3-Column Glass Card ("Rise helps you to:")
                    VStack(spacing: 10) {
                        Text("Rise helps you to:")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(RiseColors.textPrimary)
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)
                        
                        HStack(alignment: .top, spacing: 0) {
                            // Column 1: Stay Motivated
                            OnboardingFeatureColumn(
                                iconName: "onboarding_icon_lightbulb",
                                title: "Stay Motivated",
                                description: "Daily inspiration that keeps you moving forward."
                            )
                            
                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(width: 1, height: 92)
                            
                            // Column 2: Reflect & Grow
                            OnboardingFeatureColumn(
                                iconName: "onboarding_icon_heart",
                                title: "Reflect & Grow",
                                description: "Understand your day and become a better version of you."
                            )
                            
                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(width: 1, height: 92)
                            
                            // Column 3: Track Progress
                            OnboardingFeatureColumn(
                                iconName: "onboarding_icon_chart",
                                title: "Track Progress",
                                description: "Build consistency and celebrate every small win."
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color(hex: "#100C24").opacity(0.84))
                            
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .opacity(0.35)
                            
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            RiseColors.accentPrimary.opacity(0.14),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        RiseColors.accentPrimary.opacity(0.35),
                                        RiseColors.borderSubtle.opacity(0.50)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .riseShadow(RiseShadows.elevationHigh)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible || reduceMotion ? 0 : 16)
                    .animation(reduceMotion ? nil : .easeOut(duration: 0.65).delay(0.25), value: isVisible)
                    
                    // MARK: - Primary Warm Gold CTA Button ("Let's Get Started")
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        withAnimation(reduceMotion ? nil : RiseAnimations.modalSpring) {
                            onboardingState.advanceStep()
                        }
                    }) {
                        ZStack {
                            // Centered Title Text
                            Text("Let’s Get Started")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "#090616"))
                            
                            // Right-aligned Arrow Icon
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundStyle(Color(hex: "#090616"))
                                    .padding(.trailing, 20)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
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
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .riseShadow(RiseShadows.goldGlow)
                    }
                    .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                    .accessibilityLabel("Let's Get Started")
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible || reduceMotion ? 0 : 14)
                    .animation(reduceMotion ? nil : .easeOut(duration: 0.65).delay(0.35), value: isVisible)
                    
                    // MARK: - Secondary Account Login Link (With comfortable bottom safe area margin)
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        withAnimation(reduceMotion ? nil : RiseAnimations.modalSpring) {
                            onboardingState.validationErrorMessage = nil
                            onboardingState.currentStepIndex = OnboardingStep.login.rawValue
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(RiseColors.textSecondary)
                            Text("Log in")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(RiseColors.accentSecondary)
                        }
                    }
                    .accessibilityLabel("Already have an account? Log in")
                    .padding(.top, 4)
                }
                .padding(.horizontal, RiseSpacing.lg)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            if reduceMotion {
                isVisible = true
            } else {
                withAnimation {
                    isVisible = true
                }
            }
        }
    }
}

/// Helper component for feature columns inside the onboarding glass card.
private struct OnboardingFeatureColumn: View {
    let iconName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .accessibilityHidden(true)
            
            Text(title)
                .font(.system(size: 12.5, weight: .bold, design: .rounded))
                .foregroundStyle(RiseColors.textPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)
            
            Text(description)
                .font(.system(size: 10.5, weight: .regular))
                .foregroundStyle(RiseColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.horizontal, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview("OnboardingWelcomeView") {
    OnboardingWelcomeView()
        .environment(PreviewContainer.makeAppState())
}
