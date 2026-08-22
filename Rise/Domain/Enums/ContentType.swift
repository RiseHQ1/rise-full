//
//  ContentType.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Types of wellness content provided within Rise.
public enum ContentType: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    case motivation
    case affirmation
    case meditation
    case breathwork
    case reflection
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .motivation: return "Daily Motivation"
        case .affirmation: return "Affirmation"
        case .meditation: return "Guided Meditation"
        case .breathwork: return "Breathe & Reset"
        case .reflection: return "Evening Reflection"
        }
    }
}
