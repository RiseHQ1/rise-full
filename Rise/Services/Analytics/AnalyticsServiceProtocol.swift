//
//  AnalyticsServiceProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Protocol for application telemetry and user event logging.
public protocol AnalyticsServiceProtocol: Sendable {
    func track(event: String, parameters: [String: Any]?)
    func trackScreen(name: String)
}
