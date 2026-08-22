//
//  OnboardingContainerView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Main container view coordinating onboarding step transitions and persistent top progress navigation.
public struct OnboardingContainerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init() {}
    
    private var progressPercentageText: String? {
        switch appState.onboardingState.currentStep {
        case .login: return nil
        case .welcome: return nil
        case .focusAreas: return "17%"
        case .improvements: return "33%"
        case .motivationStyle: return "50%"
        case .routineSetup: return "67%"
        case .accountCreation: return "83%"
        case .summary: return "100%"
        default: return "100%"
        }
    }
    
    public var body: some View {
        let onboardingState = appState.onboardingState
        
        ZStack(alignment: .top) {
            // MARK: - 1. Base Dark Background
            RiseColors.backgroundPrimary
                .ignoresSafeArea()
            
            // MARK: - 2. Dynamic Screen Content Layer
            Group {
                switch onboardingState.currentStep {
                case .login:
                    OnboardingLoginView()
                        .transition(.opacity)
                case .welcome:
                    OnboardingWelcomeView()
                        .transition(.opacity)
                case .focusAreas:
                    OnboardingFocusAreasView()
                        .transition(.opacity)
                case .improvements:
                    OnboardingImprovementsView()
                        .transition(.opacity)
                case .motivationStyle:
                    OnboardingMotivationStyleView()
                        .transition(.opacity)
                case .routineSetup:
                    OnboardingRoutineSetupView()
                        .transition(.opacity)
                case .accountCreation:
                    OnboardingAccountCreationView()
                        .transition(.opacity)
                case .summary:
                    OnboardingSummaryView()
                        .transition(.opacity)
                }
            }
            .animation(
                reduceMotion ? nil : .easeInOut(duration: 0.30),
                value: onboardingState.currentStepIndex
            )
            
            // MARK: - 3. Persistent Top Navigation Bar (Positioned 8pt below status bar)
            if onboardingState.currentStep != .welcome && onboardingState.currentStep != .login {
                VStack(spacing: 0) {
                    ZStack {
                        // Back Button on Left
                        HStack {
                            if onboardingState.canGoBack {
                                RiseIconButton(
                                    iconName: "chevron.left",
                                    accessibilityLabel: "Back to previous onboarding step",
                                    style: .glass,
                                    size: 40
                                ) {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                        onboardingState.previousStep()
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                        // Centered Persistent Progress Bar
                        RiseOnboardingProgress(
                            currentStep: max(1, onboardingState.currentStepIndex - 1),
                            totalSteps: 6
                        )
                        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: onboardingState.currentStepIndex)
                        
                        // Percentage Text on Right
                        if let percentage = progressPercentageText {
                            HStack {
                                Spacer()
                                Text(percentage)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundStyle(RiseColors.accentPrimary)
                            }
                        }
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                    .padding(.top, 8) // Clean 8pt padding below status bar clock & Dynamic Island
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .zIndex(10) // Always remain anchored above scrolling content
            }
        }
    }
}

/// Temporary placeholder view for onboarding steps 5+ pending individual visual review.
public struct OnboardingPlaceholderView: View {
    @Environment(AppState.self) private var appState
    public let step: OnboardingStep
    
    public init(step: OnboardingStep) {
        self.step = step
    }
    
    public var body: some View {
        let onboardingState = appState.onboardingState
        
        ZStack {
            RiseColors.riseBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: RiseSpacing.lg) {
                Text("Step \(step.rawValue): \(step)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(RiseColors.textPrimary)
                
                Button(action: {
                    onboardingState.advanceStep()
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(hex: "#090616"))
                        .frame(width: 200, height: 48)
                        .background(RiseColors.accentSecondary)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

#Preview("OnboardingContainerView") {
    OnboardingContainerView()
        .environment(PreviewContainer.makeAppState())
}
