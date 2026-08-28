//
//  DiscoverState.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
public final class DiscoverState {
    public enum MoodNeed: String, CaseIterable, Identifiable, Sendable {
        case stressed
        case overwhelmed
        case discouraged
        case unmotivated

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .stressed: return "Stressed"
            case .overwhelmed: return "Overwhelmed"
            case .discouraged: return "Discouraged"
            case .unmotivated: return "Unmotivated"
            }
        }

        public var iconAssetName: String {
            switch self {
            case .stressed: return "discover_mood_stressed"
            case .overwhelmed: return "discover_mood_overwhelmed"
            case .discouraged: return "discover_mood_discouraged"
            case .unmotivated: return "discover_mood_unmotivated"
            }
        }
    }

    public struct CategoryItem: Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let title: String
        public let count: Int
        public let iconAssetName: String
        public let backgroundAssetName: String
    }

    public struct FeaturedItem: Identifiable, Hashable, Sendable {
        public let id: UUID
        public let tag: String
        public let tagSystemIcon: String
        public let tagColorHex: String
        public let quote: String
        public let highlight: String?
        public let backgroundAssetName: String
        public var likeCount: Int
        public var isLiked: Bool

        public init(
            id: UUID = UUID(),
            tag: String,
            tagSystemIcon: String,
            tagColorHex: String,
            quote: String,
            highlight: String? = nil,
            backgroundAssetName: String,
            likeCount: Int = 4800,
            isLiked: Bool = false
        ) {
            self.id = id
            self.tag = tag
            self.tagSystemIcon = tagSystemIcon
            self.tagColorHex = tagColorHex
            self.quote = quote
            self.highlight = highlight
            self.backgroundAssetName = backgroundAssetName
            self.likeCount = likeCount
            self.isLiked = isLiked
        }

        public var likeCountLabel: String {
            if likeCount >= 1000 {
                let k = Double(likeCount) / 1000.0
                return String(format: "%.1fk", k)
            }
            return "\(likeCount)"
        }

        public var isSaved: Bool {
            SavedContentStore.shared.isSaved(title: quote)
        }
    }

    public struct TrendingTopic: Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let title: String
        public let viewsLabel: String
        public let iconAssetName: String
        public let accentHex: String
    }

    public var searchText: String = ""
    public var selectedMood: MoodNeed? = .stressed
    public var didTapGetHelp: Bool = false
    public var didTapNotifications: Bool = false
    public var didTapSeeAllCategories: Bool = false
    public var didTapSeeAllFeatured: Bool = false
    public var didTapSeeAllTrending: Bool = false

    public var categories: [CategoryItem] = [
        .init(title: "Motivation", count: 128, iconAssetName: "onboarding_icon_motivation", backgroundAssetName: "onboarding_motivation_bg"),
        .init(title: "Discipline", count: 96, iconAssetName: "onboarding_icon_discipline", backgroundAssetName: "onboarding_focus_bg"),
        .init(title: "Focus", count: 84, iconAssetName: "onboarding_icon_target", backgroundAssetName: "onboarding_improvements_bg"),
        .init(title: "Self Growth", count: 112, iconAssetName: "onboarding_icon_growth", backgroundAssetName: "onboarding_summary_bg"),
        .init(title: "Mindset", count: 88, iconAssetName: "onboarding_icon_brain", backgroundAssetName: "splash_sunrise_scene"),
    ]

    public var featured: [FeaturedItem] = [
        .init(
            tag: "Daily Boost",
            tagSystemIcon: "sparkles",
            tagColorHex: "#F59E0B",
            quote: "Small steps every day lead to big changes over time.",
            highlight: "Keep showing up.",
            backgroundAssetName: "onboarding_motivation_bg",
            likeCount: 4820,
            isLiked: false
        ),
        .init(
            tag: "Mindset",
            tagSystemIcon: "sparkles",
            tagColorHex: "#8B5CF6",
            quote: "Your future is created by what you do today, not tomorrow.",
            highlight: nil,
            backgroundAssetName: "splash_sunrise_scene",
            likeCount: 3240,
            isLiked: true
        ),
        .init(
            tag: "Discipline",
            tagSystemIcon: "mountain.2.fill",
            tagColorHex: "#10B981",
            quote: "Discipline is choosing what you want most over what you want now.",
            highlight: nil,
            backgroundAssetName: "onboarding_focus_bg",
            likeCount: 5120,
            isLiked: false
        ),
    ]

    public var trending: [TrendingTopic] = [
        .init(title: "Building Habits", viewsLabel: "24.1k", iconAssetName: "onboarding_icon_discipline", accentHex: "#8B5CF6"),
        .init(title: "Morning Routine", viewsLabel: "18.7k", iconAssetName: "onboarding_icon_morning", accentHex: "#F59E0B"),
        .init(title: "Overcoming Fear", viewsLabel: "16.3k", iconAssetName: "onboarding_icon_growth", accentHex: "#A5A1C8"),
        .init(title: "Consistency", viewsLabel: "21.4k", iconAssetName: "onboarding_icon_refresh", accentHex: "#10B981"),
    ]

    public init() {}

    public func selectMood(_ mood: MoodNeed) {
        selectedMood = mood
    }

    public func toggleFeaturedLike(_ item: FeaturedItem) {
        guard let index = featured.firstIndex(where: { $0.id == item.id }) else { return }
        if featured[index].isLiked {
            featured[index].isLiked = false
            featured[index].likeCount = max(0, featured[index].likeCount - 1)
        } else {
            featured[index].isLiked = true
            featured[index].likeCount += 1
        }
    }

    public func toggleFeaturedSaved(_ item: FeaturedItem) {
        SavedContentStore.shared.toggleSave(
            title: item.quote,
            subtitle: item.tag,
            category: "Motivation",
            assetName: item.backgroundAssetName
        )
    }

    public func loadServerContent() async {
        guard RiseAPIClient.shared.isAuthenticated else { return }
        do {
            struct DiscoverResponse: Decodable {
                struct CategoryDTO: Decodable {
                    let id: String
                    let title: String
                    let count: Int
                    let backgroundAssetName: String
                }

                struct FeaturedDTO: Decodable {
                    let id: String
                    let tag: String
                    let tagSystemIcon: String
                    let tagColorHex: String
                    let quote: String
                    let highlight: String?
                    let backgroundAssetName: String
                    let likeCount: Int
                    let isLiked: Bool
                }

                struct TrendingDTO: Decodable {
                    let id: String
                    let title: String
                    let viewsLabel: String
                    let iconAssetName: String
                    let accentHex: String
                }

                let categories: [CategoryDTO]?
                let featured: [FeaturedDTO]?
                let trending: [TrendingDTO]?
            }

            let result: DiscoverResponse = try await RiseAPIClient.shared.request(
                endpoint: "discover",
                method: "GET"
            )

            if let serverCategories = result.categories, !serverCategories.isEmpty {
                categories = serverCategories.map {
                    CategoryItem(title: $0.title, count: $0.count, iconAssetName: "onboarding_icon_motivation", backgroundAssetName: $0.backgroundAssetName)
                }
            }

            if let serverFeatured = result.featured, !serverFeatured.isEmpty {
                featured = serverFeatured.map {
                    FeaturedItem(
                        tag: $0.tag,
                        tagSystemIcon: $0.tagSystemIcon,
                        tagColorHex: $0.tagColorHex,
                        quote: $0.quote,
                        highlight: $0.highlight,
                        backgroundAssetName: $0.backgroundAssetName,
                        likeCount: $0.likeCount,
                        isLiked: $0.isLiked
                    )
                }
            }

            if let serverTrending = result.trending, !serverTrending.isEmpty {
                trending = serverTrending.map {
                    TrendingTopic(title: $0.title, viewsLabel: $0.viewsLabel, iconAssetName: $0.iconAssetName, accentHex: $0.accentHex)
                }
            }
        } catch {
            RiseLogger.warning("Discover server fetch notice: \(error.localizedDescription)")
        }
    }
}
