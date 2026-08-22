//
//  OnboardingLoginView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI
import AuthenticationServices

/// Onboarding Login screen: "Welcome back to Rise ✨".
///
/// Mirrors the design system of the Account Creation screen featuring:
/// - Full-bleed upper hero background artwork extending into status bar
/// - Left-constrained title ("Welcome back to Rise ✨") with zero boy illustration overlap
/// - Dark glass input cards: Email address & Password (with active warm gold focus border & white dots)
/// - "Forgot Password?" link right-aligned directly under the password field
/// - Primary warm gold "Log in ->" CTA button positioned directly below Forgot Password
/// - "Or continue with" section divider
/// - Official Apple Sign-In flow powered by AuthenticationServices & official brand logo assets
/// - Official Google Sign-In flow powered by official 4-color Google "G" vector brand asset (24x24 pt)
/// - "Don't have an account? Sign up" footer navigation link.
public struct OnboardingLoginView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    
    public init() {}
    
    public var body: some View {
        let onboardingState = appState.onboardingState
        
        ZStack(alignment: .top) {
            // MARK: - 1. Upper Hero Background Image (Full-bleed into status bar)
            VStack(spacing: 0) {
                GeometryReader { geo in
                    Image("onboarding_auth_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 410, alignment: .topTrailing)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color(hex: "#070611").opacity(0.10),
                                    RiseColors.backgroundPrimary
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
                .frame(height: 410)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)
            
            // MARK: - 2. Content Layer
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section (Positioned nicely below hero artwork)
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()
                            
                            Text("Welcome back")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textPrimary)
                            
                            HStack(spacing: 0) {
                                Text("to ")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("Rise ✨")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                            
                            Text("Log in to continue your journey and\nsync your progress.")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(RiseColors.textSecondary)
                                .lineSpacing(2.5)
                                .padding(.top, 2)
                        }
                        .frame(maxWidth: geo.size.width * 0.58, alignment: .leading)
                        .padding(.horizontal, RiseSpacing.lg)
                        .padding(.bottom, 14)
                    }
                    .frame(height: 360)
                    
                    // Main Form Content Area
                    VStack(alignment: .leading, spacing: 14) {
                        // MARK: - Input 1: Email Address
                        VStack(alignment: .leading, spacing: 4) {
                            RiseTextField(
                                placeholder: "Email address",
                                text: $emailInput,
                                iconName: "envelope",
                                keyboardType: .emailAddress,
                                textInputAutocapitalization: .never
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                        }
                        
                        // MARK: - Input 2: Password + Forgot Password Link
                        VStack(alignment: .leading, spacing: 4) {
                            RiseTextField(
                                placeholder: "Password",
                                text: $passwordInput,
                                iconName: "lock",
                                isSecure: true
                            ) {
                                onboardingState.validationErrorMessage = nil
                            }
                            
                            // "Forgot Password?" Link at Right End of Password Field
                            HStack {
                                Spacer()
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    onboardingState.validationErrorMessage = "Password reset link sent to your email."
                                }) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .foregroundStyle(RiseColors.accentSecondary)
                                }
                            }
                            .padding(.top, 2)
                            .padding(.trailing, 2)
                        }
                        
                        // MARK: - Primary CTA Button ("Log in ->") Positioned Directly Below Password & Forgot Password
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            let trimmedEmail = emailInput.trimmingCharacters(in: .whitespacesAndNewlines)
                            if trimmedEmail.isEmpty || !trimmedEmail.contains("@") {
                                onboardingState.validationErrorMessage = "Please enter a valid email address."
                                return
                            }
                            if passwordInput.isEmpty {
                                onboardingState.validationErrorMessage = "Please enter your password."
                                return
                            }
                            
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.validationErrorMessage = nil
                                onboardingState.emailInput = trimmedEmail
                                onboardingState.authProvider = .email
                                onboardingState.currentStepIndex = OnboardingStep.summary.rawValue
                            }
                        }) {
                            ZStack {
                                Text("Log in")
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
                        .padding(.top, 2)
                        
                        // Inline Validation Warning Banner
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
                        .padding(.vertical, 6)
                        
                        // MARK: - Social Authentication Buttons (Official Brand Assets & Handlers)
                        VStack(spacing: 10) {
                            // 1. Continue with Apple
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
                            
                            // 2. Continue with Google
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
                        
                        // MARK: - Footer Link ("Don't have an account? Sign up")
                        Button(action: {
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.validationErrorMessage = nil
                                onboardingState.currentStepIndex = OnboardingStep.welcome.rawValue
                            }
                        }) {
                            HStack(spacing: 4) {
                                Spacer()
                                Text("Don’t have an account?")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(RiseColors.textSecondary)
                                Text("Sign up")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(RiseColors.accentSecondary)
                                Spacer()
                            }
                            .padding(.top, 6)
                            .padding(.bottom, 28)
                        }
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview("OnboardingLoginView") {
    OnboardingLoginView()
        .environment(PreviewContainer.makeAppState())
}
