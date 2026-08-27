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

    public static let serverBaseURL = "http://64.177.41.52:3000/api/v1"
    public static let serverDomain = "64-177-41-52.sslip.io"

    public enum StorageKeys {
        public static let hasCompletedOnboarding = "has_completed_onboarding"
        public static let userProfile = "user_profile"
        public static let lastActiveDate = "last_active_date"
    }
}
