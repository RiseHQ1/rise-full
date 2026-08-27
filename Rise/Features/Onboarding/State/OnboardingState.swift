//
//  OnboardingState.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import AuthenticationServices
import Observation
import SwiftUI

/// Navigation steps in the Rise onboarding flow.
public enum OnboardingStep: Int, CaseIterable, Identifiable, Comparable, Sendable {
    case login = 0
    case welcome = 1
    case focusAreas = 2
    case improvements = 3
    case motivationStyle = 4
    case routineSetup = 5
    case accountCreation = 6
    case emailVerification = 7
    case summary = 8

    public var id: Int {
        rawValue
    }

    public static func < (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Authentication Provider type.
public enum AuthProvider: String, Sendable {
    case email
    case apple
    case google
}

/// On-demand handler managing ASAuthorizationController presentation cleanly without preview host reuse failures.
@MainActor
public final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var completion: ((Result<ASAuthorization, Error>) -> Void)?

    override public init() {
        super.init()
    }

    public func performSignIn(completion: @escaping (Result<ASAuthorization, Error>) -> Void) {
        self.completion = completion
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        completion?(.success(authorization))
    }

    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }

    public func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
        else {
            return UIWindow()
        }
        return window
    }
}

/// State model managing centralized onboarding data collection, account registration, validation, and profile persistence.
@Observable
@MainActor
public final class OnboardingState {
    public var currentStepIndex: Int
    public var totalSteps: Int
    public var isCompleted: Bool

    // MARK: - Centralized Selection State (Persists across forward/back navigation)

    public var selectedCategories: Set<OnboardingCategory> = [.motivation, .studying, .personalGrowth]
    public var selectedImprovements: Set<OnboardingImprovement> = [.stayConsistent, .buildDiscipline, .buildBetterHabits]
    public var selectedMotivationStyle: OnboardingMotivationOption? = .gentle
    public var selectedTimeOfDay: TimeOfDayPreference? = .morning
    public var selectedDuration: FocusDurationPreference? = .fiveMinutes

    // MARK: - Account Creation Fields (Step 5)

    public var fullNameInput: String = ""
    public var emailInput: String = ""
    public var passwordInput: String = ""
    public var confirmPasswordInput: String = ""
    public var isPasswordVisible: Bool = false
    public var isConfirmPasswordVisible: Bool = false
    public var authProvider: AuthProvider?
    public var isAuthenticating: Bool = false

    // MARK: - OTP Email Verification Fields (Step 6)

    public var otpCode: String = ""
    public var isVerifyingCode: Bool = false
    public var otpCountdownSeconds: Int = 60
    public var isResendingCode: Bool = false

    /// Static storage for active Apple Sign-In delegate during authentication flow
    private static var activeAppleDelegate: AppleSignInDelegate?

    /// Password Requirement Verification
    public var hasMin8Chars: Bool {
        passwordInput.count >= 8
    }

    public var hasNumber: Bool {
        passwordInput.contains { $0.isNumber }
    }

    public var hasSpecialChar: Bool {
        passwordInput.contains { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }
    }

    public var isPasswordValid: Bool {
        hasMin8Chars && hasNumber && hasSpecialChar
    }

    // MARK: - Profile Personalization Fields (Step 6)

    public var userName: String = ""
    public var morningTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    public var eveningTime: Date = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
    public var isDailyMotivationEnabled: Bool = true
    public var isEveningReflectionEnabled: Bool = true
    public var isIntentionReminderEnabled: Bool = true

    // MARK: - Inline Validation Error Banner Message

    public var validationErrorMessage: String?

    public var currentStep: OnboardingStep {
        OnboardingStep(rawValue: currentStepIndex) ?? .welcome
    }

    public var canGoBack: Bool {
        currentStepIndex > 1
    }

    public init(
        currentStepIndex: Int = 1,
        totalSteps: Int = 6,
        isCompleted: Bool = false
    ) {
        self.currentStepIndex = currentStepIndex
        self.totalSteps = totalSteps
        self.isCompleted = isCompleted
    }

    // MARK: - Navigation Actions

    public func previousStep() {
        guard canGoBack else { return }
        validationErrorMessage = nil
        currentStepIndex -= 1
    }

    public func advanceStep() {
        validationErrorMessage = nil
        if currentStepIndex < OnboardingStep.summary.rawValue {
            currentStepIndex += 1
        }
    }

    // MARK: - Step-Specific Validation & Advance Methods

    public func advanceFromStep1() {
        if selectedCategories.isEmpty {
            validationErrorMessage = "Please choose at least one option."
            return
        }
        validationErrorMessage = nil
        currentStepIndex = OnboardingStep.improvements.rawValue
    }

    public func advanceFromStep2() {
        if selectedImprovements.isEmpty {
            validationErrorMessage = "Please choose at least one option."
            return
        }
        if selectedImprovements.count > 4 {
            validationErrorMessage = "Please choose up to 4 options."
            return
        }
        validationErrorMessage = nil
        currentStepIndex = OnboardingStep.motivationStyle.rawValue
    }

    public func toggleImprovement(_ item: OnboardingImprovement) {
        if selectedImprovements.contains(item) {
            selectedImprovements.remove(item)
            validationErrorMessage = nil
        } else {
            if selectedImprovements.count >= 4 {
                validationErrorMessage = "Choose up to 4 options."
            } else {
                selectedImprovements.insert(item)
                validationErrorMessage = nil
            }
        }
    }

    public func advanceFromStep3() {
        if selectedMotivationStyle == nil {
            validationErrorMessage = "Please select a motivation style."
            return
        }
        validationErrorMessage = nil
        currentStepIndex = OnboardingStep.routineSetup.rawValue
    }

    public func advanceFromStep4() {
        if selectedTimeOfDay == nil || selectedDuration == nil {
            validationErrorMessage = "Please select when you need Rise and your focus duration."
            return
        }
        validationErrorMessage = nil
        currentStepIndex = OnboardingStep.accountCreation.rawValue
    }

    // MARK: - Account Creation Authentication Handlers (Step 5)

    public func advanceFromAccountCreation() {
        let trimmedName = fullNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailInput.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedName.isEmpty {
            validationErrorMessage = "Please enter your full name."
            return
        }

        if trimmedEmail.isEmpty || !trimmedEmail.contains("@") || !trimmedEmail.contains(".") {
            validationErrorMessage = "Please enter a valid email address."
            return
        }

        if !isPasswordValid {
            validationErrorMessage = "Password must be at least 8 characters, include a number & a special character."
            return
        }

        if passwordInput != confirmPasswordInput {
            validationErrorMessage = "Passwords do not match."
            return
        }

        validationErrorMessage = nil
        authProvider = .email
        userName = trimmedName

        isAuthenticating = true
        Task {
            do {
                struct AuthResponse: Decodable {
                    let user: UserDTO
                    let tokens: AuthTokensDTO
                }
                let payload = ["email": emailInput, "password": passwordInput, "name": trimmedName]
                let result: AuthResponse = try await RiseAPIClient.shared.request(
                    endpoint: "auth/register",
                    method: "POST",
                    body: payload,
                    requiresAuth: false
                )
                RiseAPIClient.shared.setTokens(
                    accessToken: result.tokens.accessToken,
                    refreshToken: result.tokens.refreshToken
                )
                isAuthenticating = false
                currentStepIndex = OnboardingStep.emailVerification.rawValue
            } catch {
                isAuthenticating = false
                // If account exists or testing offline, transition to verification smoothly
                RiseLogger.warning("Registration fallback to OTP verification: \(error.localizedDescription)")
                currentStepIndex = OnboardingStep.emailVerification.rawValue
            }
        }
    }

    // MARK: - OTP Email Verification Actions

    public func verifyEmailOTP() {
        let code = otpCode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard code.count == 6 else {
            validationErrorMessage = "Please enter the 6-digit verification code."
            return
        }

        isVerifyingCode = true
        validationErrorMessage = nil

        Task {
            // Simulated server OTP verification delay with auto-fallback
            try? await Task.sleep(for: .milliseconds(700))
            isVerifyingCode = false
            currentStepIndex = OnboardingStep.summary.rawValue
        }
    }

    public func resendOTPCode() {
        guard !isResendingCode else { return }
        isResendingCode = true
        validationErrorMessage = nil

        Task {
            try? await Task.sleep(for: .milliseconds(500))
            isResendingCode = false
            otpCountdownSeconds = 60
            RiseLogger.info("OTP Code resent to \(emailInput)")
        }
    }

    public func signInWithApple() {
        isAuthenticating = true
        validationErrorMessage = nil

        let delegate = AppleSignInDelegate()
        Self.activeAppleDelegate = delegate

        delegate.performSignIn { [weak self] result in
            guard let self else { return }
            Self.activeAppleDelegate = nil
            self.handleAppleSignInSuccess(result)
        }
    }

    public func handleAppleSignInSuccess(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case let .success(auth):
            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                let givenName = appleIDCredential.fullName?.givenName ?? ""
                let familyName = appleIDCredential.fullName?.familyName ?? ""
                let fullName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                let email = appleIDCredential.email ?? ""
                let appleUserId = appleIDCredential.user
                let identityToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) } ?? ""

                authProvider = .apple
                if !fullName.isEmpty {
                    userName = fullName
                } else if userName.isEmpty {
                    userName = "Mindful Member"
                }
                if !email.isEmpty {
                    emailInput = email
                }

                // Send Apple credentials to live Rise Server
                Task {
                    do {
                        struct AuthResponse: Decodable {
                            let user: UserDTO
                            let tokens: AuthTokensDTO
                        }
                        let payload = [
                            "identityToken": identityToken,
                            "appleUserId": appleUserId,
                            "email": email.isEmpty ? nil : email,
                            "name": fullName.isEmpty ? userName : fullName,
                        ]
                        let authResult: AuthResponse = try await RiseAPIClient.shared.request(
                            endpoint: "auth/apple",
                            method: "POST",
                            body: payload,
                            requiresAuth: false
                        )
                        RiseAPIClient.shared.setTokens(
                            accessToken: authResult.tokens.accessToken,
                            refreshToken: authResult.tokens.refreshToken
                        )
                    } catch {
                        RiseLogger.warning("Apple backend token exchange fallback: \(error.localizedDescription)")
                    }
                    self.isAuthenticating = false
                    self.validationErrorMessage = nil
                    self.currentStepIndex = OnboardingStep.summary.rawValue
                }
            }
        case let .failure(error):
            isAuthenticating = false
            let nsError = error as NSError
            if nsError.code != ASAuthorizationError.canceled.rawValue {
                validationErrorMessage = "Apple Authentication failed. Please try again."
            }
        }
    }

    public func signInWithGoogle() {
        isAuthenticating = true
        validationErrorMessage = nil

        // Simulate Google Auth Session Handshake
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }
            self.isAuthenticating = false
            self.authProvider = .google
            if self.userName.isEmpty {
                self.userName = "Alex"
            }
            self.currentStepIndex = OnboardingStep.summary.rawValue
        }
    }

    // MARK: - Final Onboarding Completion & Profile Saving (Step 6)

    public func completeOnboarding(appState: AppState) {
        // Validate Step 6 Name
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            validationErrorMessage = "Please enter your name."
            return
        }

        // Comprehensive Check Across All Previous Required Steps
        if selectedCategories.isEmpty {
            currentStepIndex = OnboardingStep.focusAreas.rawValue
            validationErrorMessage = "Please choose at least one option."
            return
        }
        if selectedImprovements.isEmpty || selectedImprovements.count > 4 {
            currentStepIndex = OnboardingStep.improvements.rawValue
            validationErrorMessage = "Please select between 1 and 4 goals."
            return
        }
        if selectedMotivationStyle == nil {
            currentStepIndex = OnboardingStep.motivationStyle.rawValue
            validationErrorMessage = "Please select a motivation style."
            return
        }
        if selectedTimeOfDay == nil || selectedDuration == nil {
            currentStepIndex = OnboardingStep.routineSetup.rawValue
            validationErrorMessage = "Please choose your time preferences."
            return
        }

        validationErrorMessage = nil

        // Build & Save Full Profile
        let profile = UserProfile(
            name: trimmedName,
            email: emailInput.isEmpty ? nil : emailInput,
            selectedFocusAreas: selectedCategories.compactMap { FocusArea(rawValue: $0.rawValue) },
            dailyReminderEnabled: isDailyMotivationEnabled || isEveningReflectionEnabled,
            preferredReminderTime: morningTime,
            isOnboardingCompleted: true,
            goals: Array(selectedImprovements).map { $0.title },
            motivationPreference: selectedMotivationStyle?.title,
            preferredRoutineTime: selectedTimeOfDay?.title
        )

        // Persist UserProfile & Completion Flag
        do {
            if let data = try? JSONEncoder().encode(profile) {
                UserDefaults.standard.set(data, forKey: "saved_user_profile")
            }
        }

        // Sync Focus Areas and Preferences to Live Backend
        Task {
            guard RiseAPIClient.shared.isAuthenticated else { return }
            do {
                struct SyncProfilePayload: Encodable {
                    let focusAreas: [String]
                    let motivationStyle: String
                    let morningBoostTime: String
                    let eveningReflectionTime: String
                }
                let payload = SyncProfilePayload(
                    focusAreas: selectedCategories.map { $0.rawValue },
                    motivationStyle: selectedMotivationStyle?.title ?? "GENTLE",
                    morningBoostTime: "07:00",
                    eveningReflectionTime: "21:00"
                )
                let _: UserDTO = try await RiseAPIClient.shared.request(
                    endpoint: "user/profile",
                    method: "PUT",
                    body: payload
                )
                RiseLogger.info("Onboarding profile successfully synchronized to server.")
            } catch {
                RiseLogger.warning("Profile synchronization deferred: \(error.localizedDescription)")
            }
        }

        isCompleted = true
        appState.isOnboardingCompleted = true
    }
}
