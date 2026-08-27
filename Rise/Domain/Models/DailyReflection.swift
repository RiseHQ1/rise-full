//
//  DailyReflection.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Evening reflection response and mood evaluation.
public struct DailyReflection: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let date: Date
    public var prompt: String
    public var response: String
    public var eveningMood: Mood?

    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        prompt: String = "What brought you peace or fulfillment today?",
        response: String = "",
        eveningMood: Mood? = nil
    ) {
        self.id = id
        self.date = date
        self.prompt = prompt
        self.response = response
        self.eveningMood = eveningMood
    }
}
