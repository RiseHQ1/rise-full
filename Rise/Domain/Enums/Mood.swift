//
//  Mood.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// User mood states for check-ins, journal entries, and reflections.
public enum Mood: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    case peaceful
    case energized
    case grateful
    case reflective
    case stressed
    case unfocused

    public var id: String {
        rawValue
    }

    public var displayName: String {
        switch self {
        case .peaceful: return "Peaceful"
        case .energized: return "Energized"
        case .grateful: return "Grateful"
        case .reflective: return "Reflective"
        case .stressed: return "Stressed"
        case .unfocused: return "Unfocused"
        }
    }

    public var emoji: String {
        switch self {
        case .peaceful: return "🕊️"
        case .energized: return "⚡️"
        case .grateful: return "✨"
        case .reflective: return "🌙"
        case .stressed: return "🌧️"
        case .unfocused: return "💭"
        }
    }
}
