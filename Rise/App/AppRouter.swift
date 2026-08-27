//
//  AppRouter.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Observation
import SwiftUI

/// Strongly-typed app-level routes for major application navigation.
public enum AppRoute: Hashable, Sendable {
    case settings
    case savedContent
    case motivationDetail(MotivationItem)
    case focusAreaDetail(FocusArea)

    // MARK: - Phase 2 feature screens

    case needSomethingNow(moodTitle: String)
    case search
    case motivationCategories
    case dailyIntention
    case intentionComplete
    case morningBoost
    case affirmations
    case affirmationReader(initialId: UUID)
    case breatheReset
    case eveningReflection
    case journalHistory
    case newJournalEntry
    case journalEntryDetail(title: String)
    case saved
    case savedMotivation
    case notifications

    // MARK: - Profile sub-screens

    case notificationPreferences
    case reminderSchedule
    case languageSettings
    case personalInformation
    case privacySecurity
    case backupRestore
    case editStatusQuote
    case risePlanEdit
    case manageFocusAreas

    // MARK: - Commerce & Packs
    case paywall
    case packDetail(title: String, category: String, durationDays: Int, isPro: Bool, artworkAsset: String)
}

/// Centralized app-level router coordinating root flow transitions and major cross-feature navigation.
@Observable
@MainActor
public final class AppRouter {
    public var homePath = NavigationPath()
    public var discoverPath = NavigationPath()
    public var journalPath = NavigationPath()
    public var progressPath = NavigationPath()
    public var profilePath = NavigationPath()

    public init() {}

    public func binding(for tab: AppTab) -> Binding<NavigationPath> {
        Binding(
            get: {
                switch tab {
                case .home: return self.homePath
                case .discover: return self.discoverPath
                case .journal: return self.journalPath
                case .progress: return self.progressPath
                case .profile: return self.profilePath
                }
            },
            set: { newValue in
                switch tab {
                case .home: self.homePath = newValue
                case .discover: self.discoverPath = newValue
                case .journal: self.journalPath = newValue
                case .progress: self.progressPath = newValue
                case .profile: self.profilePath = newValue
                }
            }
        )
    }

    public func push(_ route: AppRoute, on tab: AppTab) {
        switch tab {
        case .home: homePath.append(route)
        case .discover: discoverPath.append(route)
        case .journal: journalPath.append(route)
        case .progress: progressPath.append(route)
        case .profile: profilePath.append(route)
        }
    }

    public func popToRoot(for tab: AppTab) {
        switch tab {
        case .home: homePath = NavigationPath()
        case .discover: discoverPath = NavigationPath()
        case .journal: journalPath = NavigationPath()
        case .progress: progressPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }
}
