//
//  AppTab.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Primary navigation tabs in Rise.
public enum AppTab: String, CaseIterable, Identifiable, Hashable, Sendable {
    case home
    case discover
    case journal
    case progress
    case profile

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .home: return "Home"
        case .discover: return "Discover"
        case .journal: return "Journal"
        case .progress: return "Progress"
        case .profile: return "Profile"
        }
    }

    public var systemIconName: String {
        switch self {
        case .home: return "house.fill"
        case .discover: return "sparkles"
        case .journal: return "book.closed"
        case .progress: return "chart.bar.fill"
        case .profile: return "person.fill"
        }
    }
}
