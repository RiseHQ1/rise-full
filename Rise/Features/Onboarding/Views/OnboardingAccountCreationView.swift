//
//  OnboardingAccountCreationView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import AuthenticationServices
import SwiftUI

// Onboarding Step 5: "Create your Rise account" registration & social authentication screen.

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
                    Image("onboarding_account_creation_bg")
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

                            Text("Create your")
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.textPrimary)

                            HStack(spacing: 0) {
                                Text("Rise ")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.accentSecondary)
                                Text("account ✨")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.textPrimary)
                            }

                            Text("Let’s get you set up so you\ncan start your journey.")
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
                                .font(RiseTypography.micro)
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
                                .font(RiseTypography.micro)
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
                                .font(RiseTypography.micro)
                                .foregroundStyle(RiseColors.textSecondary)
                                .padding(.leading, 4)
                        }

                        // MARK: - Section Divider ("Or continue with")

                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 1)

                            Text("Or continue with")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.textSecondary)

                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 4)

                        // MARK: - Social Authentication Buttons (Official Brand Assets & Handlers)

                        VStack(spacing: 10) {
                            // 1. Continue with Apple
                            Button {
                                withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                    onboardingState.signInWithApple()
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image("auth_apple_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)

                                    Text("Continue with Apple")
                                        .font(RiseTypography.calloutSemibold)
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceField.opacity(0.82))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .stroke(RiseColors.borderHairline, lineWidth: 1)
                                }
                            }
                            .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))

                            // 2. Continue with Google
                            Button {
                                withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                    onboardingState.signInWithGoogle()
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    if onboardingState.isAuthenticatingSocial {
                                        ProgressView()
                                            .tint(.white)
                                            .frame(width: 24, height: 24)
                                    } else {
                                        Image("auth_google_logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }

                                    Text(onboardingState.isAuthenticatingSocial ? "Connecting..." : "Continue with Google")
                                        .font(RiseTypography.calloutSemibold)
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .fill(RiseColors.surfaceField.opacity(0.82))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                        .stroke(RiseColors.borderHairline, lineWidth: 1)
                                }
                            }
                            .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                            .disabled(onboardingState.isAuthenticating)
                        }

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

                        RisePrimaryButton(
                            onboardingState.isAuthenticatingEmail ? "Creating account..." : "Create account",
                            iconName: onboardingState.isAuthenticatingEmail ? nil : "arrow.right",
                            isLoading: onboardingState.isAuthenticatingEmail,
                            style: .gold
                        ) {
                            onboardingState.advanceFromAccountCreation()
                        }
                        .padding(.top, 4)
                        .disabled(onboardingState.isAuthenticating)

                        // MARK: - Footer Lock & Terms Note

                        (
                            Text("\(Image(systemName: "lock.fill"))  By creating an account, you agree to our ")
                                .font(RiseTypography.micro)
                                .foregroundStyle(RiseColors.textMuted)
                                + Text("Terms of Service")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.accentSecondary)
                                + Text(" and ")
                                .font(RiseTypography.micro)
                                .foregroundStyle(RiseColors.textMuted)
                                + Text("Privacy Policy.")
                                .font(RiseTypography.microSemibold)
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
                .font(RiseTypography.microBold)
                .foregroundStyle(isSatisfied ? RiseColors.success : RiseColors.textMuted)

            Text(title)
                .font(RiseTypography.micro)
                .foregroundStyle(isSatisfied ? RiseColors.textPrimary : RiseColors.textSecondary)
        }
    }
}

#Preview("OnboardingAccountCreationView") {
    OnboardingAccountCreationView()
        .environment(PreviewContainer.makeAppState())
}
