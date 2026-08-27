//
//  UserProfileStore.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import Observation
import SwiftUI

/// Centralized observable reactive store for the User Profile across Rise.
@Observable
@MainActor
public final class UserProfileStore {
    public static let shared = UserProfileStore()

    public var name: String = "Friend"
    public var email: String = "alex@riseapp.com"
    public var statusQuote: String = "Small steps today, stronger tomorrow."
    public var memberSince: String = "Rise since May 2025"

    public var planWeeklyDays: Int = 5
    public var planFocusMinutes: Int = 10
    public var planCommitment: String = "Morning reflection & box breathing"

    public var selectedTheme: String = "Dark"
    public var selectedLanguage: String = "English"

    public var activeFocusAreaIds: [String] = ["discipline", "mindset", "selfGrowth"]

    public var morningBoostTime: String = "7:00 AM"
    public var eveningReflectionTime: String = "9:00 PM"
    public var middayNudgeEnabled: Bool = false
    public var middayNudgeTime: String = "1:00 PM"

    public var notificationsDailyMotivation: Bool = true
    public var notificationsEveningReflection: Bool = true
    public var notificationsIntentionReminder: Bool = true
    public var notificationsStreakUpdates: Bool = true
    public var notificationsWeeklySummary: Bool = false

    public var faceIDLock: Bool = false
    public var hideJournalPreviews: Bool = true
    public var analyticsSharing: Bool = false
    public var personalizedContent: Bool = true

    public var iCloudBackup: Bool = true
    public var lastBackupDate: String = "Today at 8:30 AM"

    // Today's Daily Intention
    public var todayIntention: String?
    public var todayIntentionFocus: String?
    public var todayIntentionAction: String?
    public var todayIntentionWhy: String?
    public var todayIntentionCompleted: Bool = false

    private let profileKey = "saved_user_profile"

    public init() {
        loadProfile()
    }

    public var firstName: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Friend"
        }
        return String(trimmed.split(separator: " ").first ?? "Friend")
    }

    public var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2, let f = parts.first?.first, let l = parts.last?.first {
            return "\(f)\(l)".uppercased()
        }
        if let f = name.first {
            return String(f).uppercased()
        }
        return "R"
    }

    public func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data),
           !profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            name = profile.name
            email = profile.email ?? "alex@riseapp.com"
        }

        if let quote = UserDefaults.standard.string(forKey: "profile_status_quote"), !quote.isEmpty {
            statusQuote = quote
        }

        if let theme = UserDefaults.standard.string(forKey: "profile_selected_theme") {
            selectedTheme = theme
        }

        if let lang = UserDefaults.standard.string(forKey: "profile_language") {
            selectedLanguage = lang
        }

        if let focusIds = UserDefaults.standard.array(forKey: "progress_managed_focus_ids") as? [String], !focusIds.isEmpty {
            activeFocusAreaIds = focusIds
        }

        morningBoostTime = UserDefaults.standard.string(forKey: "profile_morning_boost_time") ?? "7:00 AM"
        eveningReflectionTime = UserDefaults.standard.string(forKey: "profile_evening_reflection_time") ?? "9:00 PM"
        middayNudgeEnabled = UserDefaults.standard.bool(forKey: "profile_midday_nudge_enabled")
        middayNudgeTime = UserDefaults.standard.string(forKey: "profile_midday_nudge_time") ?? "1:00 PM"

        if let notifObj = UserDefaults.standard.object(forKey: "notif_daily_motivation") as? Bool {
            notificationsDailyMotivation = notifObj
        }
        if let notifObj = UserDefaults.standard.object(forKey: "notif_evening_reflection") as? Bool {
            notificationsEveningReflection = notifObj
        }
        if let notifObj = UserDefaults.standard.object(forKey: "notif_intention_reminder") as? Bool {
            notificationsIntentionReminder = notifObj
        }
        if let notifObj = UserDefaults.standard.object(forKey: "notif_streak_updates") as? Bool {
            notificationsStreakUpdates = notifObj
        }
        if let notifObj = UserDefaults.standard.object(forKey: "notif_weekly_summary") as? Bool {
            notificationsWeeklySummary = notifObj
        }

        if let intention = UserDefaults.standard.string(forKey: "today_intention_text"), !intention.isEmpty {
            todayIntention = intention
            todayIntentionFocus = UserDefaults.standard.string(forKey: "today_intention_focus") ?? "Mindset"
            todayIntentionAction = UserDefaults.standard.string(forKey: "today_intention_action") ?? ""
            todayIntentionWhy = UserDefaults.standard.string(forKey: "today_intention_why") ?? ""
            todayIntentionCompleted = UserDefaults.standard.bool(forKey: "today_intention_completed")
        }
    }

    public func saveNameAndEmail(name newName: String, email newEmail: String) {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        name = trimmedName
        email = trimmedEmail.isEmpty ? "alex@riseapp.com" : trimmedEmail

        var profile = UserProfile(name: trimmedName)
        profile.email = trimmedEmail.isEmpty ? nil : trimmedEmail
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }

    public func saveStatusQuote(_ quote: String) {
        let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)
        statusQuote = trimmed.isEmpty ? "Small steps today, stronger tomorrow." : trimmed
        UserDefaults.standard.set(statusQuote, forKey: "profile_status_quote")
    }

    public func saveDailyIntention(text: String, focus: String, action: String, why: String) {
        todayIntention = text
        todayIntentionFocus = focus
        todayIntentionAction = action
        todayIntentionWhy = why
        todayIntentionCompleted = true

        UserDefaults.standard.set(text, forKey: "today_intention_text")
        UserDefaults.standard.set(focus, forKey: "today_intention_focus")
        UserDefaults.standard.set(action, forKey: "today_intention_action")
        UserDefaults.standard.set(why, forKey: "today_intention_why")
        UserDefaults.standard.set(true, forKey: "today_intention_completed")

        // Sync Intention to live PostgreSQL Database
        Task {
            guard RiseAPIClient.shared.isAuthenticated else { return }
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: Date())

                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let nowIso = isoFormatter.string(from: Date())

                struct CreateIntentionPayload: Encodable {
                    let syncId: String
                    let date: String
                    let text: String
                    let category: String
                    let isCustom: Bool
                    let isCompleted: Bool
                    let clientCreatedAt: String
                    let clientUpdatedAt: String
                }

                let payload = CreateIntentionPayload(
                    syncId: UUID().uuidString,
                    date: dateString,
                    text: text,
                    category: focus,
                    isCustom: true,
                    isCompleted: false,
                    clientCreatedAt: nowIso,
                    clientUpdatedAt: nowIso
                )

                struct IntentionResponse: Decodable {
                    let id: String
                }

                let _: IntentionResponse = try await RiseAPIClient.shared.request(
                    endpoint: "intentions",
                    method: "POST",
                    body: payload
                )
                RiseLogger.info("Daily intention successfully saved to PostgreSQL database.")
            } catch {
                RiseLogger.warning("Intention server sync notice: \(error.localizedDescription)")
            }
        }
    }

    public func clearDailyIntention() {
        todayIntention = nil
        todayIntentionFocus = nil
        todayIntentionAction = nil
        todayIntentionWhy = nil
        todayIntentionCompleted = false

        UserDefaults.standard.removeObject(forKey: "today_intention_text")
        UserDefaults.standard.removeObject(forKey: "today_intention_focus")
        UserDefaults.standard.removeObject(forKey: "today_intention_action")
        UserDefaults.standard.removeObject(forKey: "today_intention_why")
        UserDefaults.standard.removeObject(forKey: "today_intention_completed")
    }
}
