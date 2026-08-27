//
//  OnboardingEmailVerificationView.swift
//  Rise
//
//  Created by Rise Team on 27/08/2026.
//

import SwiftUI

/// Onboarding Step 7: "Verify your email" OTP 6-digit security code input screen.
public struct OnboardingEmailVerificationView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @FocusState private var focusedIndex: Int?
    @State private var digits: [String] = Array(repeating: "", count: 6)
    @State private var timer: Timer?

    public init() {}

    public var body: some View {
        let onboardingState = appState.onboardingState

        ZStack(alignment: .top) {
            // MARK: - 1. Hero Sunset Scene Background
            VStack(spacing: 0) {
                GeometryReader { geo in
                    Image("onboarding_account_creation_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 280, alignment: .topTrailing)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .clear, location: 0.50),
                                    .init(color: Color(hex: "#070611").opacity(0.50), location: 0.80),
                                    .init(color: RiseColors.backgroundPrimary, location: 1.0),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
                .frame(height: 280)

                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)

            // MARK: - 2. Content Layer
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Verify your")
                            .font(RiseTypography.heroCompact)
                            .foregroundStyle(RiseColors.textPrimary)

                        HStack(spacing: 0) {
                            Text("email ")
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.accentSecondary)
                            Text("code 📬")
                                .font(RiseTypography.heroCompact)
                                .foregroundStyle(RiseColors.textPrimary)
                        }

                        Text("We sent a 6-digit code to ")
                            .font(RiseTypography.footnote)
                            .foregroundStyle(RiseColors.textSecondary)
                            + Text(onboardingState.emailInput.isEmpty ? "your email address" : onboardingState.emailInput)
                            .font(RiseTypography.footnoteBold)
                            .foregroundStyle(RiseColors.textPrimary)
                            + Text(". Enter it below to activate your account.")
                            .font(RiseTypography.footnote)
                            .foregroundStyle(RiseColors.textSecondary)
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                    .padding(.top, 140)
                    .padding(.bottom, 24)

                    // MARK: - 3. 6-Digit OTP Cells
                    VStack(spacing: 18) {
                        HStack(spacing: 10) {
                            ForEach(0 ..< 6, id: \.self) { index in
                                OTPDigitField(
                                    digit: $digits[index],
                                    isFocused: focusedIndex == index,
                                    onChanged: { newValue in
                                        handleDigitChange(at: index, newValue: newValue, state: onboardingState)
                                    }
                                )
                                .focused($focusedIndex, equals: index)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)

                        // Countdown Timer & Resend Button
                        HStack(spacing: 4) {
                            Text("Didn't receive the code?")
                                .font(RiseTypography.caption)
                                .foregroundStyle(RiseColors.textSecondary)

                            if onboardingState.otpCountdownSeconds > 0 {
                                Text("Resend in \(onboardingState.otpCountdownSeconds)s")
                                    .font(RiseTypography.captionSemibold)
                                    .foregroundStyle(RiseColors.textMuted)
                            } else {
                                Button {
                                    onboardingState.resendOTPCode()
                                    startCountdown()
                                } label: {
                                    Text("Resend code")
                                        .font(RiseTypography.captionBold)
                                        .foregroundStyle(RiseColors.accentSecondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 4)

                        // Inline Validation Warning
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

                        // MARK: - Verify Primary Button
                        RisePrimaryButton(
                            onboardingState.isVerifyingCode ? "Verifying..." : "Verify & Continue",
                            iconName: onboardingState.isVerifyingCode ? nil : "arrow.right",
                            isLoading: onboardingState.isVerifyingCode,
                            style: .gold
                        ) {
                            onboardingState.otpCode = digits.joined()
                            withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
                                onboardingState.verifyEmailOTP()
                            }
                        }
                        .padding(.top, 8)
                        .disabled(digits.joined().count < 6 || onboardingState.isVerifyingCode)
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .onAppear {
            focusedIndex = 0
            startCountdown()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                if appState.onboardingState.otpCountdownSeconds > 0 {
                    appState.onboardingState.otpCountdownSeconds -= 1
                } else {
                    timer?.invalidate()
                }
            }
        }
    }

    private func handleDigitChange(at index: Int, newValue: String, state: OnboardingState) {
        let filtered = newValue.filter { $0.isNumber }
        if filtered.count > 1 {
            // Handle paste of 6 digits
            let chars = Array(filtered.prefix(6))
            for i in 0 ..< chars.count {
                digits[i] = String(chars[i])
            }
            focusedIndex = min(chars.count, 5)
            state.otpCode = digits.joined()
            return
        }

        digits[index] = String(filtered.prefix(1))
        if !digits[index].isEmpty {
            if index < 5 {
                focusedIndex = index + 1
            } else {
                focusedIndex = nil
                state.otpCode = digits.joined()
            }
        }
    }
}

// MARK: - OTP Digit Field Component

private struct OTPDigitField: View {
    @Binding var digit: String
    let isFocused: Bool
    let onChanged: (String) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(RiseColors.surfaceField.opacity(0.85))
                .frame(width: 48, height: 56)
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(
                            isFocused ? RiseColors.accentSecondary : RiseColors.borderHairline,
                            lineWidth: isFocused ? 2 : 1
                        )
                }
                .riseShadow(isFocused ? RiseShadows.goldGlow : RiseShadows.elevationLow)

            TextField("", text: $digit)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(RiseColors.textPrimary)
                .onChange(of: digit) { _, newValue in
                    onChanged(newValue)
                }
        }
        .frame(width: 48, height: 56)
    }
}

#Preview {
    OnboardingEmailVerificationView()
        .environment(PreviewContainer.makeAppState())
}
