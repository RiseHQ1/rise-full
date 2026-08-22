//
//  MotivationItem.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Motivational quote or daily inspiration item.
public struct MotivationItem: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let quote: String
    public let author: String
    public let category: FocusArea
    public var isFavorite: Bool
    public let date: Date
    
    public init(
        id: UUID = UUID(),
        quote: String,
        author: String,
        category: FocusArea = .clarity,
        isFavorite: Bool = false,
        date: Date = Date()
    ) {
        self.id = id
        self.quote = quote
        self.author = author
        self.category = category
        self.isFavorite = isFavorite
        self.date = date
    }
}
