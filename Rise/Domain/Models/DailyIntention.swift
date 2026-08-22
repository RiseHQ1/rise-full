//
//  DailyIntention.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// User's set intention for the day.
public struct DailyIntention: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let date: Date
    public var text: String
    public var focusArea: FocusArea
    public var isCompleted: Bool
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        text: String,
        focusArea: FocusArea = .clarity,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.date = date
        self.text = text
        self.focusArea = focusArea
        self.isCompleted = isCompleted
    }
}
