//
//  ProfileView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Profile tab matching the approved Profile mockup.
public struct ProfileView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppState.self) private var appState
    @State private var state = ProfileState()
    @State private var showPaywall = false

    public init() {}

    public var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    header

                    // Extra room so the boy / mug hero reads clearly above the profile card.
                    Color.clear
                        .frame(height: 92)

                    profileCard
                    risePlusBanner
                    quoteCard
                    risePlanSection
                    preferencesSection
                    accountSection
                    continueCard
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.top, RiseSpacing.xs)
                .riseTabBarScrollClearance()
            }
            .onAppear { state.loadProfile() }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showPaywall) {
            RisePaywallView()
        }
        .alert("Log Out?", isPresented: $state.showLogOutConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                logOut()
            }
        } message: {
            Text("You’ll return to onboarding. Your local journal stays on this device until you clear it.")
        }
    }

    private var backgroundLayer: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                RiseTabBar.ambientBottom

                Image("profile_tab_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.08),
                            Color.clear,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 56)

                    Spacer(minLength: 0)

                    LinearGradient(
                        colors: [
                            Color.clear,
                            RiseTabBar.ambientBottom.opacity(0.22),
                            RiseTabBar.ambientBottom.opacity(0.70),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.32)
                }
                .allowsHitTesting(false)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Profile")
                .font(RiseTypography.display)
                .foregroundStyle(RiseColors.textPrimary)
            Text("Manage your experience and keep rising.")
                .font(RiseTypography.body)
                .foregroundStyle(RiseColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var profileCard: some View {
        Button {
            appRouter.push(.personalInformation, on: .profile)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(RiseColors.accentPrimary, lineWidth: 2)
                        .frame(width: 54, height: 54)
                        .shadow(color: RiseColors.accentPrimary.opacity(0.45), radius: 8)
                    Circle()
                        .fill(RiseColors.accentPrimary.opacity(0.25))
                        .frame(width: 48, height: 48)
                    Text(state.initials)
                        .font(RiseTypography.headlineBold)
                        .foregroundStyle(RiseColors.textPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(state.fullName)
                        .font(RiseTypography.buttonBold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text(state.memberSinceLabel)
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                    Text("Member")
                        .font(RiseTypography.microSemibold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(RiseColors.accentPrimary.opacity(0.35))
                        .clipShape(Capsule())
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(RiseTypography.calloutSemibold)
                    .foregroundStyle(RiseColors.accentPrimary)
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(state.fullName), \(state.memberSinceLabel), Member")
        .accessibilityHint("Opens personal information.")
    }

    private var risePlusBanner: some View {
        Button {
            RiseHaptic.impact(.medium)
            showPaywall = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(RiseColors.gold.opacity(0.18))
                        .frame(width: 42, height: 42)
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(RiseColors.gold)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Rise+ Unlimited")
                            .font(RiseTypography.bodyBold)
                            .foregroundStyle(RiseColors.textPrimary)
                        Text("PRO")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(RiseColors.backgroundPrimary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(RiseColors.gold)
                            .clipShape(Capsule())
                    }

                    Text("Unlimited AI Boosts, 8 Packs & Soundscapes")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(RiseTypography.captionBold)
                    .foregroundStyle(RiseColors.gold)
            }
            .padding(14)
            .background(
                LinearGradient(
                    colors: [
                        RiseColors.gold.opacity(0.12),
                        RiseColors.surfacePrimary.opacity(0.7),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: RiseRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: RiseRadius.card)
                    .stroke(RiseColors.gold.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("Rise Plus Unlimited, Pro membership banner")
    }

    private var quoteCard: some View {
        HStack(spacing: 10) {
            Image(systemName: "quote.opening")
                .font(RiseTypography.calloutBold)
                .foregroundStyle(RiseColors.accentPrimary)
                .accessibilityHidden(true)

            Text(state.statusQuote)
                .font(RiseTypography.calloutSemibold)
                .foregroundStyle(RiseColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                appRouter.push(.editStatusQuote, on: .profile)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
                .font(RiseTypography.captionSemibold)
                .foregroundStyle(RiseColors.accentPrimary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit status quote")
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.large)
        .accessibilityElement(children: .contain)
    }

    private var risePlanSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            HStack {
                Text("Your Rise Plan")
                    .font(RiseTypography.headlineBold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button {
                    appRouter.push(.risePlanEdit, on: .profile)
                } label: {
                    HStack(spacing: 2) {
                        Text("View & Edit")
                        Image(systemName: "chevron.right")
                            .font(RiseTypography.microSemibold)
                    }
                    .font(RiseTypography.footnoteSemibold)
                    .foregroundStyle(RiseColors.accentPrimary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("View and edit Rise plan")
            }

            HStack(spacing: 0) {
                planColumn(icon: "onboarding_icon_sun", title: "Morning Boost", value: state.morningBoostTime)
                Divider().background(RiseColors.borderSubtle).frame(height: 54)
                planColumn(icon: "onboarding_icon_moon", title: "Evening Reflection", value: state.eveningReflectionTime)
                Divider().background(RiseColors.borderSubtle).frame(height: 54)
                planColumn(icon: "onboarding_icon_target", title: "Focus Time", value: state.focusDuration)
            }
            .padding(.vertical, 12)
            .riseRichGlass(cornerRadius: RiseRadius.card)
        }
    }

    private func planColumn(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(title)
                .font(RiseTypography.microSemibold)
                .foregroundStyle(RiseColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(RiseTypography.captionBold)
                .foregroundStyle(RiseColors.accentSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            Text("Preferences")
                .font(RiseTypography.headlineBold)
                .foregroundStyle(RiseColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(Array(state.preferenceRows.enumerated()), id: \.element.id) { index, row in
                    preferenceRow(row)
                    if index < state.preferenceRows.count - 1 {
                        Divider().background(RiseColors.borderHairline)
                    }
                }
            }
            .padding(.horizontal, 12)
            .riseRichGlass(cornerRadius: RiseRadius.card)
        }
    }

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            Text("Account")
                .font(RiseTypography.headlineBold)
                .foregroundStyle(RiseColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(Array(state.accountRows.enumerated()), id: \.element.id) { index, row in
                    preferenceRow(row)
                    if index < state.accountRows.count - 1 {
                        Divider().background(RiseColors.borderHairline)
                    }
                }
            }
            .padding(.horizontal, 12)
            .riseRichGlass(cornerRadius: RiseRadius.card)
        }
    }

    private func preferenceRow(_ row: ProfileState.PreferenceRow) -> some View {
        let rowButton = Button {
            RiseHaptic.impact(.light)
            handlePreferenceTap(row)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: row.systemIcon)
                    .font(RiseTypography.calloutSemibold)
                    .foregroundStyle(row.kind == .destructive ? RiseColors.error : RiseColors.accentPrimary)
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(row.title)
                        .font(RiseTypography.subheadlineSemibold)
                        .foregroundStyle(row.kind == .destructive ? RiseColors.error : RiseColors.textPrimary)
                    Text(row.subtitle)
                        .font(RiseTypography.caption)
                        .foregroundStyle(row.kind == .destructive ? RiseColors.error.opacity(0.8) : RiseColors.textSecondary)
                }

                Spacer()

                trailing(for: row)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        return Group {
            if case .theme = row.kind {
                rowButton
                    .accessibilityElement(children: .contain)
            } else {
                rowButton
                    .accessibilityLabel(preferenceAccessibilityLabel(for: row))
            }
        }
    }

    private func preferenceAccessibilityLabel(for row: ProfileState.PreferenceRow) -> String {
        switch row.kind {
        case let .language(value):
            return "\(row.title), \(row.subtitle), \(value)"
        case .theme:
            return "\(row.title), \(row.subtitle), \(state.selectedTheme.title)"
        case .chevron, .destructive:
            return "\(row.title), \(row.subtitle)"
        }
    }

    @ViewBuilder
    private func trailing(for row: ProfileState.PreferenceRow) -> some View {
        switch row.kind {
        case .chevron, .destructive:
            Image(systemName: "chevron.right")
                .font(RiseTypography.captionSemibold)
                .foregroundStyle(row.kind == .destructive ? RiseColors.error.opacity(0.7) : RiseColors.textMuted)
        case let .language(value):
            HStack(spacing: 2) {
                Text(value)
                Image(systemName: "chevron.right")
            }
            .font(RiseTypography.captionSemibold)
            .foregroundStyle(RiseColors.textSecondary)
        case .theme:
            HStack(spacing: 0) {
                ForEach(ProfileState.AppThemeOption.allCases) { option in
                    Button {
                        RiseHaptic.selection()
                        state.setTheme(option)
                    } label: {
                        Text(option.title)
                            .font(RiseTypography.microBold)
                            .foregroundStyle(
                                state.selectedTheme == option
                                    ? RiseColors.textOnGold
                                    : RiseColors.textSecondary
                            )
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background {
                                if state.selectedTheme == option {
                                    Capsule().fill(RiseColors.accentSecondary)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(option.title) theme")
                    .accessibilityAddTraits(state.selectedTheme == option ? [.isSelected] : [])
                }
            }
            .padding(3)
            .background(Capsule().fill(RiseColors.surfaceField.opacity(0.85)))
        }
    }

    private var continueCard: some View {
        HStack(spacing: 12) {
            Image("onboarding_icon_sprout_soil")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                Text("Keep growing, \(state.firstName).")
                    .font(RiseTypography.subheadlineBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("You're becoming the person you're meant to be.")
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            Spacer(minLength: 0)

            RiseGoldCapsuleButton(
                "Continue My Journey",
                iconName: "chevron.right",
                height: 36,
                cornerRadius: 12
            ) {
                state.didTapContinue = true
                appRouter.push(.morningBoost, on: .profile)
            }
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private func handlePreferenceTap(_ row: ProfileState.PreferenceRow) {
        guard let destination = row.destination else { return }
        if destination == .logOut {
            state.showLogOutConfirm = true
            return
        }
        if let route = state.route(for: destination) {
            appRouter.push(route, on: .profile)
        }
    }

    private func logOut() {
        appState.isOnboardingCompleted = false
        appState.isAuthenticated = false
        appRouter.popToRoot(for: .profile)
    }
}

#Preview("ProfileView") {
    ProfileView()
        .environment(AppRouter())
        .environment(AppState())
}
