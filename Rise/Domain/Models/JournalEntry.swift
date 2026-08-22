//
//  JournalEntry.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Personal journal entry capturing reflections, thoughts, and mood.
public struct JournalEntry: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let createdAt: Date
    public var updatedAt: Date
    public var title: String
    public var content: String
    public var mood: Mood?
    public var tags: [String]
    
    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        title: String = "",
        content: String = "",
        mood: Mood? = nil,
        tags: [String] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        self.content = content
        self.mood = mood
        self.tags = tags
    }
}
