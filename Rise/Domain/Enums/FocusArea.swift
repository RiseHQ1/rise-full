//
//  FocusArea.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Core wellness focus areas for personalization and content filtering.
public enum FocusArea: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    case mindfulness
    case clarity
    case resilience
    case sleep
    case productivity
    case gratitude

    public var id: String {
        rawValue
    }

    public var displayName: String {
        switch self {
        case .mindfulness: return "Mindfulness"
        case .clarity: return "Clarity"
        case .resilience: return "Resilience"
        case .sleep: return "Sleep & Rest"
        case .productivity: return "Focus & Flow"
        case .gratitude: return "Gratitude"
        }
    }

    public var iconName: String {
        switch self {
        case .mindfulness: return "sparkles"
        case .clarity: return "sun.max"
        case .resilience: return "shield"
        case .sleep: return "moon.stars"
        case .productivity: return "bolt"
        case .gratitude: return "heart"
        }
    }
}
