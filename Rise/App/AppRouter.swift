//
//  AppRouter.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI
import Observation

/// Strongly-typed app-level routes for major application navigation.
public enum AppRoute: Hashable, Sendable {
    case settings
    case savedContent
    case motivationDetail(MotivationItem)
    case focusAreaDetail(FocusArea)
}

/// Centralized app-level router coordinating root flow transitions and major cross-feature navigation.
/// Individual feature views retain local navigation state where appropriate.
@Observable
@MainActor
public final class AppRouter {
    /// Navigation paths maintained per root tab.
    public var homePath = NavigationPath()
    public var discoverPath = NavigationPath()
    public var journalPath = NavigationPath()
    public var progressPath = NavigationPath()
    public var profilePath = NavigationPath()
    
    public init() {}
    
    /// Returns the NavigationPath binding corresponding to a given tab.
    public func path(for tab: AppTab) -> NavigationPath {
        switch tab {
        case .home: return homePath
        case .discover: return discoverPath
        case .journal: return journalPath
        case .progress: return progressPath
        case .profile: return profilePath
        }
    }
    
    /// Resets navigation path back to root for the specified tab.
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
