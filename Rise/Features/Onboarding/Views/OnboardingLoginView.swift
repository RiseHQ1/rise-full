//
//  OnboardingLoginView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import AuthenticationServices
import SwiftUI

// Onboarding Login screen: "Welcome back to Rise ✨".

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
                                    RiseColors.backgroundPrimary,
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
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.textPrimary)

                            HStack(spacing: 0) {
                                Text("to ")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text("Rise ✨")
                                    .font(RiseTypography.heroCompact)
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }

                            Text("Log in to continue your journey and\nsync your progress.")
                                .font(RiseTypography.footnote)
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
                                Button {
                                    onboardingState.validationErrorMessage = "Password reset link sent to your email."
                                } label: {
                                    Text("Forgot Password?")
                                        .font(RiseTypography.captionSemibold)
                                        .foregroundStyle(RiseColors.accentSecondary)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.top, 2)
                            .padding(.trailing, 2)
                        }

                        // MARK: - Primary CTA Button ("Log in ->") Positioned Directly Below Password & Forgot Password

                        RisePrimaryButton(
                            onboardingState.isAuthenticatingEmail ? "Logging in..." : "Log in",
                            iconName: onboardingState.isAuthenticatingEmail ? nil : "arrow.right",
                            isLoading: onboardingState.isAuthenticatingEmail,
                            style: .gold
                        ) {
                            let trimmedEmail = emailInput.trimmingCharacters(in: .whitespacesAndNewlines)
                            if trimmedEmail.isEmpty || !trimmedEmail.contains("@") {
                                onboardingState.validationErrorMessage = "Please enter a valid email address."
                                return
                            }
                            if passwordInput.isEmpty {
                                onboardingState.validationErrorMessage = "Please enter your password."
                                return
                            }

                            onboardingState.isAuthenticatingEmail = true
                            onboardingState.validationErrorMessage = nil

                            Task { @MainActor in
                                do {
                                    struct LoginPayload: Encodable {
                                        let email: String
                                        let password: String
                                    }
                                    struct LoginResponse: Decodable {
                                        let user: UserDTO
                                        let tokens: AuthTokensDTO
                                    }
                                    let payload = LoginPayload(email: trimmedEmail, password: passwordInput)
                                    let result: LoginResponse = try await RiseAPIClient.shared.request(
                                        endpoint: "auth/login",
                                        method: "POST",
                                        body: payload,
                                        requiresAuth: false
                                    )
                                    RiseAPIClient.shared.setTokens(
                                        accessToken: result.tokens.accessToken,
                                        refreshToken: result.tokens.refreshToken
                                    )
                                    onboardingState.userName = result.user.name
                                    onboardingState.emailInput = trimmedEmail
                                    onboardingState.authProvider = .email
                                    onboardingState.isAuthenticatingEmail = false
                                    onboardingState.validationErrorMessage = nil

                                    // Persist logged in user profile
                                    let profile = UserProfile(
                                        name: result.user.name,
                                        email: trimmedEmail,
                                        selectedFocusAreas: result.user.focusAreas?.compactMap { FocusArea(rawValue: $0.lowercased()) } ?? [.mindfulness, .productivity],
                                        dailyReminderEnabled: true,
                                        preferredReminderTime: Date(),
                                        isOnboardingCompleted: true,
                                        goals: ["Stay Consistent", "Build Discipline"],
                                        motivationPreference: result.user.motivationStyle,
                                        preferredRoutineTime: "Morning"
                                    )
                                    if let data = try? JSONEncoder().encode(profile) {
                                        UserDefaults.standard.set(data, forKey: "saved_user_profile")
                                    }

                                    onboardingState.isCompleted = true
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                        appState.isOnboardingCompleted = true
                                    }
                                } catch {
                                    onboardingState.isAuthenticatingEmail = false
                                    RiseLogger.error("Login error: \(error.localizedDescription)")
                                    onboardingState.validationErrorMessage = "Invalid email or password. Please check and try again."
                                }
                            }
                        }
                        .padding(.top, 2)
                        .disabled(onboardingState.isAuthenticating)

                        // Inline Validation Warning Banner
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

                            // 2. Continue with Google
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                    onboardingState.signInWithGoogle()
                                }
                            }) {
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
                                    .font(RiseTypography.footnote)
                                    .foregroundStyle(RiseColors.textSecondary)
                                Text("Sign up")
                                    .font(RiseTypography.footnoteBold)
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
