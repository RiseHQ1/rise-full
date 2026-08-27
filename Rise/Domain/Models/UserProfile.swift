//
//  UserProfile.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Represents the user's local profile, selected focus areas, and preferences.
public struct UserProfile: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var name: String
    public var email: String?
    public var selectedFocusAreas: [FocusArea]
    public var dailyReminderEnabled: Bool
    public var preferredReminderTime: Date?
    public var createdAt: Date

    // Onboarding Personalization Preferences
    public var isOnboardingCompleted: Bool
    public var currentMood: Mood?
    public var goals: [String]
    public var motivationPreference: String?
    public var preferredRoutineTime: String?

    public init(
        id: UUID = UUID(),
        name: String = "",
        email: String? = nil,
        selectedFocusAreas: [FocusArea] = [.mindfulness, .clarity],
        dailyReminderEnabled: Bool = true,
        preferredReminderTime: Date? = nil,
        createdAt: Date = Date(),
        isOnboardingCompleted: Bool = false,
        currentMood: Mood? = nil,
        goals: [String] = [],
        motivationPreference: String? = nil,
        preferredRoutineTime: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.selectedFocusAreas = selectedFocusAreas
        self.dailyReminderEnabled = dailyReminderEnabled
        self.preferredReminderTime = preferredReminderTime
        self.createdAt = createdAt
        self.isOnboardingCompleted = isOnboardingCompleted
        self.currentMood = currentMood
        self.goals = goals
        self.motivationPreference = motivationPreference
        self.preferredRoutineTime = preferredRoutineTime
    }
}
