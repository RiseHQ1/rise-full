//
//  NotificationsState.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import Foundation
import Observation

@Observable
@MainActor
public final class NotificationsState {
    public enum Filter: String, CaseIterable, Identifiable, Sendable {
        case all
        case unread

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .all: return "All"
            case .unread: return "Unread"
            }
        }
    }

    public enum Kind: String, Sendable {
        case streak
        case intention
        case motivation
        case journal
        case achievement
        case reminder

        public var systemIcon: String {
            switch self {
            case .streak: return "flame.fill"
            case .intention: return "target"
            case .motivation: return "sparkles"
            case .journal: return "book.fill"
            case .achievement: return "trophy.fill"
            case .reminder: return "bell.fill"
            }
        }

        public var accentHex: String {
            switch self {
            case .streak: return "#F59E0B"
            case .intention: return "#8B5CF6"
            case .motivation: return "#A78BFA"
            case .journal: return "#38BDF8"
            case .achievement: return "#FFD868"
            case .reminder: return "#C4B5FD"
            }
        }
    }

    public struct Item: Identifiable, Hashable, Sendable {
        public let id: UUID
        public let kind: Kind
        public let title: String
        public let body: String
        public let timeLabel: String
        public var isUnread: Bool

        public init(
            id: UUID = UUID(),
            kind: Kind,
            title: String,
            body: String,
            timeLabel: String,
            isUnread: Bool
        ) {
            self.id = id
            self.kind = kind
            self.title = title
            self.body = body
            self.timeLabel = timeLabel
            self.isUnread = isUnread
        }
    }

    public var filter: Filter = .all
    public var items: [Item] = [
        .init(
            kind: .streak,
            title: "Keep your streak alive",
            body: "You’re on a 17-day streak. Open Rise and check in before midnight.",
            timeLabel: "2m ago",
            isUnread: true
        ),
        .init(
            kind: .intention,
            title: "Set today’s intention",
            body: "One clear intention can shape your whole day. What will you focus on?",
            timeLabel: "1h ago",
            isUnread: true
        ),
        .init(
            kind: .motivation,
            title: "Your Morning Boost is ready",
            body: "A short dose of motivation is waiting — start strong in under 2 minutes.",
            timeLabel: "3h ago",
            isUnread: true
        ),
        .init(
            kind: .journal,
            title: "Evening reflection reminder",
            body: "Capture one win and one lesson from today before you wind down.",
            timeLabel: "Yesterday",
            isUnread: false
        ),
        .init(
            kind: .achievement,
            title: "New milestone unlocked",
            body: "You’ve completed 15 goals this month. That’s real progress — keep rising.",
            timeLabel: "Yesterday",
            isUnread: false
        ),
        .init(
            kind: .reminder,
            title: "Focus time",
            body: "Your 10-minute focus block starts soon. Clear one small task.",
            timeLabel: "2d ago",
            isUnread: false
        ),
    ]

    public var unreadCount: Int {
        items.filter(\.isUnread).count
    }

    public var visibleItems: [Item] {
        switch filter {
        case .all: return items
        case .unread: return items.filter(\.isUnread)
        }
    }

    public init() {}

    public func selectFilter(_ filter: Filter) {
        self.filter = filter
    }

    public func markAsRead(_ item: Item) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isUnread = false
    }

    public func markAllAsRead() {
        for index in items.indices {
            items[index].isUnread = false
        }
    }
}
