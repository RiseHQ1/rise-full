//
//  HapticServiceProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Protocol abstracting sensory haptic feedback on the main actor.
@MainActor
public protocol HapticServiceProtocol: Sendable {
    func impact(style: HapticStyle)
    func notification(type: HapticNotificationType)
    func selection()
}

public enum HapticStyle: Sendable {
    case light
    case medium
    case heavy
    case soft
    case rigid
}

public enum HapticNotificationType: Sendable {
    case success
    case warning
    case error
}
