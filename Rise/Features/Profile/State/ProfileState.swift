//
//  ProfileState.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import Foundation
import Observation

@Observable
@MainActor
public final class ProfileState {
    public enum AppThemeOption: String, CaseIterable, Identifiable, Sendable {
        case system
        case dark
        case light

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .system: return "System"
            case .dark: return "Dark"
            case .light: return "Light"
            }
        }
    }

    public enum PreferenceDestination: String, Hashable, Sendable {
        case notificationPreferences
        case reminderSchedule
        case language
        case personalInformation
        case privacySecurity
        case backupRestore
        case logOut
    }

    public struct PreferenceRow: Identifiable, Hashable, Sendable {
        public let id: String
        public let title: String
        public let subtitle: String
        public let systemIcon: String
        public let kind: Kind
        public let destination: PreferenceDestination?

        public enum Kind: Hashable, Sendable {
            case chevron
            case theme
            case language(String)
            case destructive
        }

        public init(
            id: String,
            title: String,
            subtitle: String,
            systemIcon: String,
            kind: Kind,
            destination: PreferenceDestination? = nil
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.systemIcon = systemIcon
            self.kind = kind
            self.destination = destination
        }
    }

    public var fullName: String = "Friend"
    public var memberSinceLabel: String = "Rise since May 2025"
    public var statusQuote: String = "Small steps today, stronger tomorrow."
    public var selectedTheme: AppThemeOption = .dark
    public var language: String = "English"

    public var morningBoostTime: String = "7:00 AM"
    public var eveningReflectionTime: String = "9:00 PM"
    public var focusDuration: String = "10 min/day"

    public var didTapContinue: Bool = false
    public var showLogOutConfirm: Bool = false

    public var preferenceRows: [PreferenceRow] {
        [
            .init(
                id: "notifications",
                title: RiseL10n.tr("profile.notifications"),
                subtitle: "Motivation, reflections & streaks",
                systemIcon: "bell",
                kind: .chevron,
                destination: .notificationPreferences
            ),
            .init(
                id: "reminders",
                title: RiseL10n.tr("profile.reminderSchedule"),
                subtitle: "Set motivation times",
                systemIcon: "clock",
                kind: .chevron,
                destination: .reminderSchedule
            ),
            .init(
                id: "language",
                title: RiseL10n.tr("profile.language"),
                subtitle: RiseLanguageManager.shared.currentLanguage.nativeName,
                systemIcon: "globe",
                kind: .language(RiseLanguageManager.shared.currentLanguage.nativeName),
                destination: .language
            ),
            .init(
                id: "theme",
                title: RiseL10n.tr("profile.theme"),
                subtitle: "Select visual appearance",
                systemIcon: "moon.stars",
                kind: .theme
            ),
        ]
    }

    public var accountRows: [PreferenceRow] {
        [
            .init(
                id: "personal",
                title: "Personal Information",
                subtitle: "Update your details",
                systemIcon: "person",
                kind: .chevron,
                destination: .personalInformation
            ),
            .init(
                id: "privacy",
                title: RiseL10n.tr("profile.privacySecurity"),
                subtitle: "Manage your privacy",
                systemIcon: "lock.shield",
                kind: .chevron,
                destination: .privacySecurity
            ),
            .init(
                id: "backup",
                title: RiseL10n.tr("profile.backupRestore"),
                subtitle: "Keep your journal safe",
                systemIcon: "externaldrive.badge.icloud",
                kind: .chevron,
                destination: .backupRestore
            ),
            .init(
                id: "logout",
                title: RiseL10n.tr("profile.signOut"),
                subtitle: "Sign out from your account",
                systemIcon: "rectangle.portrait.and.arrow.right",
                kind: .destructive,
                destination: .logOut
            ),
        ]
    }

    public var initials: String {
        let parts = fullName.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased().isEmpty ? "R" : letters.joined().uppercased()
    }

    public var firstName: String {
        fullName.split(separator: " ").first.map(String.init) ?? fullName
    }

    public init() {
        loadProfile()
        loadLocalPreferences()
    }

    public func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: "saved_user_profile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data),
           !profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            fullName = profile.name
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            memberSinceLabel = "Rise since \(formatter.string(from: profile.createdAt))"
        }

        if let quote = UserDefaults.standard.string(forKey: "profile_status_quote"),
           !quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            statusQuote = quote
        }

        if let morning = UserDefaults.standard.string(forKey: "profile_morning_boost_time") {
            morningBoostTime = morning
        }
        if let evening = UserDefaults.standard.string(forKey: "profile_evening_reflection_time") {
            eveningReflectionTime = evening
        }
        if let focus = UserDefaults.standard.string(forKey: "profile_focus_duration") {
            focusDuration = focus
        }
    }

    public func loadLocalPreferences() {
        if let raw = UserDefaults.standard.string(forKey: "profile_app_theme"),
           let theme = AppThemeOption(rawValue: raw)
        {
            selectedTheme = theme
        }
        if let lang = UserDefaults.standard.string(forKey: "profile_language") {
            language = lang
        }
    }

    public func setTheme(_ theme: AppThemeOption) {
        selectedTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: "profile_app_theme")
    }

    public func route(for destination: PreferenceDestination) -> AppRoute? {
        switch destination {
        case .notificationPreferences: return .notificationPreferences
        case .reminderSchedule: return .reminderSchedule
        case .language: return .languageSettings
        case .personalInformation: return .personalInformation
        case .privacySecurity: return .privacySecurity
        case .backupRestore: return .backupRestore
        case .logOut: return nil
        }
    }
}
