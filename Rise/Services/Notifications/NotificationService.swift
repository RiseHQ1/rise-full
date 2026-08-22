//
//  NotificationService.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation
import UserNotifications

/// Concrete implementation of local notifications service for Rise.
public final class NotificationService: NotificationServiceProtocol, @unchecked Sendable {
    public init() {}
    
    public func requestAuthorization() async throws -> Bool {
        // Will be connected when notification permissions are requested in UI flow
        return true
    }
    
    public func scheduleDailyReminder(at time: Date, title: String, body: String) async throws {
        // Architectural placeholder ready for UNUserNotificationCenter scheduling
    }
    
    public func cancelAllReminders() async {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
