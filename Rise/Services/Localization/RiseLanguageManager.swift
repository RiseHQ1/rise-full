//
//  RiseLanguageManager.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import Observation
import SwiftUI

/// Observable coordinator managing the active app language and layout direction in real-time.
@Observable
@MainActor
public final class RiseLanguageManager {
    public static let shared = RiseLanguageManager()

    public var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "rise_app_language_code")
            UserDefaults.standard.set(currentLanguage.nativeName, forKey: "profile_language")
            UserProfileStore.shared.selectedLanguage = currentLanguage.nativeName
        }
    }

    public var locale: Locale {
        currentLanguage.locale
    }

    public var layoutDirection: LayoutDirection {
        currentLanguage.layoutDirection
    }

    public init() {
        if let savedCode = UserDefaults.standard.string(forKey: "rise_app_language_code"),
           let lang = AppLanguage(rawValue: savedCode)
        {
            currentLanguage = lang
        } else if let savedName = UserDefaults.standard.string(forKey: "profile_language") {
            currentLanguage = AppLanguage.from(stored: savedName)
        } else {
            currentLanguage = .english
        }
    }

    public func setLanguage(_ language: AppLanguage) {
        withAnimation(RiseAnimations.interactiveSpring) {
            currentLanguage = language
        }
    }
}
