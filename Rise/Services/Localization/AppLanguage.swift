//
//  AppLanguage.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import SwiftUI

/// Supported display languages in Rise.
public enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case portuguese = "pt"
    case arabic = "ar"

    public var id: String {
        rawValue
    }

    public var nativeName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .portuguese: return "Português"
        case .arabic: return "العربية"
        }
    }

    public var englishName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .portuguese: return "Portuguese"
        case .arabic: return "Arabic"
        }
    }

    public var code: String {
        rawValue
    }

    public var locale: Locale {
        Locale(identifier: code)
    }

    public var layoutDirection: LayoutDirection {
        switch self {
        case .arabic: return .rightToLeft
        default: return .leftToRight
        }
    }

    public static func from(stored: String) -> AppLanguage {
        let lower = stored.lowercased()
        if lower.contains("español") || lower.contains("spanish") || lower == "es" {
            return .spanish
        } else if lower.contains("français") || lower.contains("french") || lower == "fr" {
            return .french
        } else if lower.contains("deutsch") || lower.contains("german") || lower == "de" {
            return .german
        } else if lower.contains("português") || lower.contains("portuguese") || lower == "pt" {
            return .portuguese
        } else if lower.contains("العربية") || lower.contains("arabic") || lower == "ar" {
            return .arabic
        }
        return .english
    }
}
