//
//  RiseShareSheet.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI
import UIKit

/// Identifiable payload for presenting `RiseShareSheet` from `.sheet(item:)`.
public struct RiseSharePayload: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let text: String

    public init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}

/// Shared iOS native activity share sheet for quotes, progress, and entries.
public struct RiseShareSheet: UIViewControllerRepresentable {
    public let items: [Any]
    public var activities: [UIActivity]?

    public init(items: [Any], activities: [UIActivity]? = nil) {
        self.items = items
        self.activities = activities
    }

    public init(payload: RiseSharePayload, activities: [UIActivity]? = nil) {
        items = [payload.text]
        self.activities = activities
    }

    public func makeUIViewController(context _: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: activities)
    }

    public func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}
