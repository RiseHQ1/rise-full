//
//  ProgressState.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
public final class ProgressState {
    public struct StatCard: Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let value: String
        public let title: String
        public let delta: String
        public let iconAssetName: String
        public let accentHex: String
    }

    public struct FocusProgress: Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let title: String
        public let percent: Double
        public let iconAssetName: String
        public let accentHex: String
    }

    public var didTapShare: Bool = false
    public var didTapManageFocus: Bool = false
    public var didTapAchievement: Bool = false
    public var selectedPeriod: String = "This Month"
    public var selectedChartMetric: String = "Journal Entries"
    public var longestStreak: Int = 23
    public var weekCompleted: Int = 6
    public var reflectionDays: Int = 18
    public var reflectionGoal: Int = 20

    public var userFirstName: String {
        UserProfileStore.shared.firstName
    }

    public var streakDays: Int {
        JournalStore.shared.streakDays
    }

    public var chartPoints: [CGFloat] {
        switch (selectedPeriod, selectedChartMetric) {
        case ("This Week", "Journal Entries"):
            return [1, 2, 1, 3, 2, 4, 3]
        case ("This Week", "Focus Minutes"):
            return [10, 15, 12, 20, 18, 25, 22]
        case ("This Week", "Reflections"):
            return [1, 1, 2, 1, 1, 2, 2]
        case ("This Month", "Journal Entries"):
            return [6, 10, 9, 14, 12, 16, 18]
        case ("This Month", "Focus Minutes"):
            return [45, 60, 55, 80, 70, 95, 110]
        case ("This Month", "Reflections"):
            return [4, 6, 5, 8, 7, 9, 10]
        case ("All Time", "Journal Entries"):
            return [20, 35, 48, 65, 82, 110, 142]
        case ("All Time", "Focus Minutes"):
            return [120, 240, 360, 520, 680, 840, 1020]
        case ("All Time", "Reflections"):
            return [15, 28, 42, 58, 74, 92, 115]
        default:
            return [6, 10, 9, 14, 12, 16, 18]
        }
    }

    public var stats: [StatCard] {
        let entryCount = max(18, JournalStore.shared.entries.count)
        return [
            .init(value: "\(entryCount)", title: "Journal Entries", delta: "+6 from last month", iconAssetName: "onboarding_icon_studying", accentHex: "#8B5CF6"),
            .init(value: "15", title: "Goals Completed", delta: "+5 from last month", iconAssetName: "onboarding_icon_target", accentHex: "#F59E0B"),
            .init(value: "12h 34m", title: "Time Invested", delta: "+2h from last month", iconAssetName: "onboarding_icon_sprout_soil", accentHex: "#14B8A6"),
            .init(value: "46", title: "Positive Days", delta: "+10 from last month", iconAssetName: "onboarding_icon_heart", accentHex: "#3B82F6"),
        ]
    }

    public var focusAreas: [FocusProgress] = []

    /// Mock heatmap intensities 0...3 — 4 weeks × 11 days (Jun → Jul sample).
    public var consistencyCells: [Int] = [
        0, 1, 3, 2, 3, 1, 0, 2, 3, 3, 1,
        2, 3, 1, 0, 2, 3, 2, 1, 3, 0, 2,
        3, 2, 3, 1, 0, 2, 3, 1, 2, 3, 0,
        1, 0, 2, 3, 2, 1, 3, 0, 1, 2, 3,
    ]

    public var consistencyMonthLabels: [(title: String, columns: Int)] = [
        ("Jun", 5),
        ("Jul", 6),
    ]

    private static let catalog: [String: FocusProgress] = [
        "discipline": .init(title: "Discipline", percent: 0.78, iconAssetName: "onboarding_icon_discipline", accentHex: "#F59E0B"),
        "mindset": .init(title: "Mindset", percent: 0.64, iconAssetName: "onboarding_icon_brain", accentHex: "#8B5CF6"),
        "selfGrowth": .init(title: "Self Growth", percent: 0.61, iconAssetName: "onboarding_icon_growth", accentHex: "#10B981"),
        "motivation": .init(title: "Motivation", percent: 0.72, iconAssetName: "onboarding_icon_motivation", accentHex: "#F59E0B"),
        "stress": .init(title: "Stress Relief", percent: 0.55, iconAssetName: "onboarding_icon_stress", accentHex: "#3B82F6"),
        "fitness": .init(title: "Fitness", percent: 0.48, iconAssetName: "onboarding_icon_fitness", accentHex: "#10B981"),
        "studying": .init(title: "Studying", percent: 0.67, iconAssetName: "onboarding_icon_studying", accentHex: "#8B5CF6"),
        "work": .init(title: "Work", percent: 0.59, iconAssetName: "onboarding_icon_work", accentHex: "#F59E0B"),
        "relationships": .init(title: "Relationships", percent: 0.52, iconAssetName: "onboarding_icon_relationships", accentHex: "#EC4899"),
    ]

    public init() {
        reloadFocusAreas()
    }

    public func loadName() {
        // Name is dynamically computed from UserProfileStore.shared.firstName
    }

    public func reloadFocusAreas() {
        let ids = UserProfileStore.shared.activeFocusAreaIds.prefix(3)
        let resolved = ids.compactMap { Self.catalog[$0] }
        focusAreas = resolved.isEmpty
            ? [
                Self.catalog["discipline"]!,
                Self.catalog["mindset"]!,
                Self.catalog["selfGrowth"]!,
            ]
            : Array(resolved)
    }
}
