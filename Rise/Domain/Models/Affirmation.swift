//
//  Affirmation.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Positive daily affirmation item.
public struct Affirmation: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let text: String
    public let category: FocusArea
    public var isFavorite: Bool

    public init(
        id: UUID = UUID(),
        text: String,
        category: FocusArea = .mindfulness,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.text = text
        self.category = category
        self.isFavorite = isFavorite
    }
}
