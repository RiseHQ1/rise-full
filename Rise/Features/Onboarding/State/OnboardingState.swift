//
//  OnboardingState.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI
import Observation
import AuthenticationServices

/// Navigation steps in the Rise onboarding flow.
public enum OnboardingStep: Int, CaseIterable, Identifiable, Comparable, Sendable {
    case login = 0
    case welcome = 1
    case focusAreas = 2
    case improvements = 3
    case motivationStyle = 4
    case routineSetup = 5
    case accountCreation = 6
    case summary = 7
    
    public var id: Int { rawValue }
    
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

/// Singleton handler managing ASAuthorizationController presentation cleanly without preview reuse failures.
@MainActor
public final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public static let shared = AppleSignInDelegate()
    
    private var completion: ((Result<ASAuthorization, Error>) -> Void)?
    
    private override init() {
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
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        completion?(.success(authorization))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first else {
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
    public var authProvider: AuthProvider? = nil
    public var isAuthenticating: Bool = false
    
    // Password Requirement Verification
    public var hasMin8Chars: Bool { passwordInput.count >= 8 }
    public var hasNumber: Bool { passwordInput.contains { $0.isNumber } }
    public var hasSpecialChar: Bool { passwordInput.contains { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) } }
    public var isPasswordValid: Bool { hasMin8Chars && hasNumber && hasSpecialChar }
    
    // MARK: - Profile Personalization Fields (Step 6)
    public var userName: String = ""
    public var morningTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    public var eveningTime: Date = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
    public var isDailyMotivationEnabled: Bool = true
    public var isEveningReflectionEnabled: Bool = true
    public var isIntentionReminderEnabled: Bool = true
    
    // MARK: - Inline Validation Error Banner Message
    public var validationErrorMessage: String? = nil
    
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
        currentStepIndex = OnboardingStep.summary.rawValue
    }
    
    public func signInWithApple() {
        isAuthenticating = true
        validationErrorMessage = nil
        AppleSignInDelegate.shared.performSignIn { [weak self] result in
            guard let self else { return }
            self.isAuthenticating = false
            self.handleAppleSignInSuccess(result)
        }
    }
    
    public func handleAppleSignInSuccess(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                let givenName = appleIDCredential.fullName?.givenName ?? ""
                let familyName = appleIDCredential.fullName?.familyName ?? ""
                let fullName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                
                authProvider = .apple
                if !fullName.isEmpty {
                    userName = fullName
                } else if userName.isEmpty {
                    userName = "Kwame"
                }
                if let email = appleIDCredential.email, !email.isEmpty {
                    emailInput = email
                }
                validationErrorMessage = nil
                currentStepIndex = OnboardingStep.summary.rawValue
            }
        case .failure(let error):
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
                self.userName = "Kwame" // Default name supplied by Google Auth
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
        
        isCompleted = true
        appState.isOnboardingCompleted = true
    }
}
