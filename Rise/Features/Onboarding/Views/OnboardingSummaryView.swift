//
//  OnboardingSummaryView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Final Onboarding Step: "Make Rise yours. ✨" personalization summary screen.
///
/// Features full-bleed upper hero artwork, left-constrained title text, name input card with reusable RiseTextField component,
/// customizable Rise moment time pickers (Morning Boost & Evening Reflection), notification preference toggles,
/// mandatory name validation, inline warning banner, warm gold "Let's Rise" CTA button, secondary "I'll set this up later" action, and privacy footer.
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
            
            // MARK: - 2. Content Layer
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section (Positioned comfortably below high top bar)
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()
                            
                            Text("Make Rise")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            
                            HStack(spacing: 4) {
                                Text("yours. ✨")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                            
                            Text("Just a few details to personalize\nyour experience.")
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
                        // MARK: - Glass Container 1: Name Input Card
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("What should we call you?")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                
                                Text("This helps us personalize your journey.")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundStyle(RiseColors.textSecondary)
                            }
                            
                            // Reusable RiseTextField Component
                            @Bindable var state = onboardingState
                            RiseTextField(
                                placeholder: "Your name",
                                text: $state.userName,
                                iconName: "person"
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                        }
                        .padding(14)
                        .background {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(hex: "#100C24").opacity(0.82))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(RiseColors.borderSubtle.opacity(0.6), lineWidth: 1)
                                }
                        }
                        
                        // MARK: - Glass Container 2: Rise Moments (Time Pickers)
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Choose your Rise moments")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                
                                Text("We’ll remind you at these times.")
                                    .font(.system(size: 11, weight: .regular))
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
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("Start your day with motivation.")
                                            .font(.system(size: 10.5, weight: .regular))
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
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#161132").opacity(0.6))
                                )
                                
                                // Evening Reflection Row
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_moon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Evening Reflection")
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("End your day with reflection.")
                                            .font(.system(size: 10.5, weight: .regular))
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
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#161132").opacity(0.6))
                                )
                            }
                        }
                        .padding(14)
                        .background {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(hex: "#100C24").opacity(0.82))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(RiseColors.borderSubtle.opacity(0.6), lineWidth: 1)
                                }
                        }
                        
                        // MARK: - Glass Container 3: Notification Preferences (Toggles)
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Notification preferences")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                
                                Text("You can change these anytime.")
                                    .font(.system(size: 11, weight: .regular))
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
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("Get your daily boost.")
                                            .font(.system(size: 10.5, weight: .regular))
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    Toggle("", isOn: $state.isDailyMotivationEnabled)
                                        .labelsHidden()
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#161132").opacity(0.6))
                                )
                                
                                // Row 2: Evening Reflection
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_moon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Evening reflection")
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("A reminder to reflect on your day.")
                                            .font(.system(size: 10.5, weight: .regular))
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    Toggle("", isOn: $state.isEveningReflectionEnabled)
                                        .labelsHidden()
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#161132").opacity(0.6))
                                )
                                
                                // Row 3: Intention Reminder
                                HStack(spacing: 10) {
                                    Image("onboarding_icon_target")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Intention reminder")
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(RiseColors.textPrimary)
                                        Text("A gentle nudge about your intention.")
                                            .font(.system(size: 10.5, weight: .regular))
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    Toggle("", isOn: $state.isIntentionReminderEnabled)
                                        .labelsHidden()
                                        .tint(RiseColors.accentSecondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#161132").opacity(0.6))
                                )
                            }
                        }
                        .padding(14)
                        .background {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(hex: "#100C24").opacity(0.82))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(RiseColors.borderSubtle.opacity(0.6), lineWidth: 1)
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
                        
                        // MARK: - Primary CTA Button ("Let's Rise ->")
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.completeOnboarding(appState: appState)
                            }
                        }) {
                            ZStack {
                                Text("Let’s Rise")
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
                            .opacity(onboardingState.userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.60 : 1.0)
                            .riseShadow(RiseShadows.goldGlow)
                        }
                        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                        .padding(.top, 2)
                        
                        // Secondary Action Button ("I'll set this up later ›")
                        Button(action: {
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.completeOnboarding(appState: appState)
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("I’ll set this up later")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(RiseColors.textSecondary)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(RiseColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                        }
                        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                        
                        // Footer Lock & Privacy Note
                        HStack(spacing: 4) {
                            Spacer()
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(RiseColors.textMuted)
                            
                            Text("Your data is private and secure. Read our ")
                                .font(.system(size: 11.5, weight: .regular))
                                .foregroundStyle(RiseColors.textMuted)
                            
                            Text("Privacy Policy.")
                                .font(.system(size: 11.5, weight: .semibold))
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
