//
//  OnboardingAccountCreationView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI
import AuthenticationServices

/// Onboarding Step 5: "Create your Rise account" registration & social authentication screen.
///
/// Faithfully reproduces the official reference design featuring:
/// - Full-bleed upper hero background artwork extending into status bar
/// - Left-constrained title ("Create your Rise account ✨") with zero boy illustration overlap
/// - Reusable RiseTextField components with active warm gold (#F59E0B) focus borders
/// - "Or continue with" section divider
/// - Official Apple Sign-In flow powered by AuthenticationServices & official brand logo assets
/// - Official Google Sign-In flow powered by official 4-color Google "G" vector brand asset (24x24 pt)
/// - Dark glass RISE button container styling preserved exactly
/// - Primary warm gold "Create account ->" CTA button
/// - Terms of Service & Privacy Policy footer note.
public struct OnboardingAccountCreationView: View {
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
                            
                            Text("Create your")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            
                            HStack(spacing: 0) {
                                Text("Rise ")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentSecondary)
                                Text("account ✨")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                            }
                            
                            Text("Let’s get you set up so you\ncan start your journey.")
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
                    
                    // Main Form Content Area
                    VStack(alignment: .leading, spacing: 14) {
                        @Bindable var state = onboardingState
                        
                        // MARK: - Input 1: Full Name
                        VStack(alignment: .leading, spacing: 4) {
                            RiseTextField(
                                placeholder: "Full name",
                                text: $state.fullNameInput,
                                iconName: "person"
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                            
                            Text("This will be how we address you.")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(RiseColors.textSecondary)
                                .padding(.leading, 4)
                        }
                        
                        // MARK: - Input 2: Email Address
                        VStack(alignment: .leading, spacing: 4) {
                            RiseTextField(
                                placeholder: "Email address",
                                text: $state.emailInput,
                                iconName: "envelope",
                                keyboardType: .emailAddress,
                                textInputAutocapitalization: .never
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                            
                            Text("We’ll use this to keep your account secure.")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(RiseColors.textSecondary)
                                .padding(.leading, 4)
                        }
                        
                        // MARK: - Input 3: Create Password
                        VStack(alignment: .leading, spacing: 4) {
                            RiseTextField(
                                placeholder: "Create password",
                                text: $state.passwordInput,
                                iconName: "lock",
                                isSecure: true
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                            
                            // Password Requirement Indicators
                            HStack(spacing: 12) {
                                PasswordRequirementItem(
                                    title: "8+ characters",
                                    isSatisfied: onboardingState.hasMin8Chars
                                )
                                PasswordRequirementItem(
                                    title: "1 number",
                                    isSatisfied: onboardingState.hasNumber
                                )
                                PasswordRequirementItem(
                                    title: "1 special character",
                                    isSatisfied: onboardingState.hasSpecialChar
                                )
                            }
                            .padding(.top, 2)
                            .padding(.leading, 4)
                        }
                        
                        // MARK: - Input 4: Confirm Password
                        VStack(alignment: .leading, spacing: 4) {
                            RiseTextField(
                                placeholder: "Confirm password",
                                text: $state.confirmPasswordInput,
                                iconName: "lock",
                                isSecure: true
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                            
                            Text("Re-enter your password.")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(RiseColors.textSecondary)
                                .padding(.leading, 4)
                        }
                        
                        // MARK: - Section Divider ("Or continue with")
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 1)
                            
                            Text("Or continue with")
                                .font(.system(size: 11.5, weight: .medium, design: .rounded))
                                .foregroundStyle(RiseColors.textSecondary)
                            
                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 4)
                        
                        // MARK: - Social Authentication Buttons (Official Brand Assets & Handlers)
                        VStack(spacing: 10) {
                            // 1. Continue with Apple (Official AuthenticationServices Apple Sign-In & Vector Logo)
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                    onboardingState.signInWithApple()
                                }
                            }) {
                                HStack(spacing: 10) {
                                    Image("auth_apple_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("Continue with Apple")
                                        .font(.system(size: 14.5, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#100C24").opacity(0.82))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(RiseColors.borderSubtle.opacity(0.6), lineWidth: 1)
                                }
                            }
                            .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                            
                            // 2. Continue with Google (Official 4-color Google "G" Vector Brand Asset at 24x24 pt)
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                    onboardingState.signInWithGoogle()
                                }
                            }) {
                                HStack(spacing: 10) {
                                    if onboardingState.isAuthenticating {
                                        ProgressView()
                                            .tint(.white)
                                            .frame(width: 24, height: 24)
                                    } else {
                                        Image("auth_google_logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                    Text(onboardingState.isAuthenticating ? "Connecting..." : "Continue with Google")
                                        .font(.system(size: 14.5, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "#100C24").opacity(0.82))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(RiseColors.borderSubtle.opacity(0.6), lineWidth: 1)
                                }
                            }
                            .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                            .disabled(onboardingState.isAuthenticating)
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
                        
                        // MARK: - Primary CTA Button ("Create account ->")
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.advanceFromAccountCreation()
                            }
                        }) {
                            ZStack {
                                Text("Create account")
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
                            .riseShadow(RiseShadows.goldGlow)
                        }
                        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                        .padding(.top, 4)
                        
                        // MARK: - Footer Lock & Terms Note
                        (
                            Text("\(Image(systemName: "lock.fill"))  By creating an account, you agree to our ")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(RiseColors.textMuted)
                            + Text("Terms of Service")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(RiseColors.accentSecondary)
                            + Text(" and ")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(RiseColors.textMuted)
                            + Text("Privacy Policy.")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(RiseColors.accentSecondary)
                        )
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 16)
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

// MARK: - Password Requirement Item Helper Component
private struct PasswordRequirementItem: View {
    let title: String
    let isSatisfied: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isSatisfied ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(isSatisfied ? Color(hex: "#10B981") : RiseColors.textMuted)
            
            Text(title)
                .font(.system(size: 10.5, weight: .regular))
                .foregroundStyle(isSatisfied ? RiseColors.textPrimary : RiseColors.textSecondary)
        }
    }
}

#Preview("OnboardingAccountCreationView") {
    OnboardingAccountCreationView()
        .environment(PreviewContainer.makeAppState())
}
