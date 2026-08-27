//
//  HapticService.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import UIKit

/// Concrete implementation of HapticServiceProtocol using UIKit feedback generators.
public final class HapticService: HapticServiceProtocol, @unchecked Sendable {
    public init() {}

    @MainActor
    public func impact(style: HapticStyle) {
        let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
        switch style {
        case .light: feedbackStyle = .light
        case .medium: feedbackStyle = .medium
        case .heavy: feedbackStyle = .heavy
        case .soft: feedbackStyle = .soft
        case .rigid: feedbackStyle = .rigid
        }
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.prepare()
        generator.impactOccurred()
    }

    @MainActor
    public func notification(type: HapticNotificationType) {
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType
        switch type {
        case .success: feedbackType = .success
        case .warning: feedbackType = .warning
        case .error: feedbackType = .error
        }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(feedbackType)
    }

    @MainActor
    public func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

/// Global static convenience access for haptic triggers across Rise views.
public enum RiseHaptic {
    private static let service = HapticService()

    @MainActor
    public static func impact(_ style: HapticStyle = .light) {
        service.impact(style: style)
    }

    @MainActor
    public static func notification(_ type: HapticNotificationType) {
        service.notification(type: type)
    }

    @MainActor
    public static func selection() {
        service.selection()
    }
}
