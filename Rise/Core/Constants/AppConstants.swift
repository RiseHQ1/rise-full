//
//  AppConstants.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Global constant values and configuration identifiers for Rise.
public enum AppConstants {
    public static let appName = "Rise"
    public static let appVersion = "1.0.0"
    public static let bundleIdentifier = "com.riseapp.Rise"

    public enum StorageKeys {
        public static let hasCompletedOnboarding = "has_completed_onboarding"
        public static let userProfile = "user_profile"
        public static let lastActiveDate = "last_active_date"
    }
}
