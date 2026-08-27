//
//  AppLogger.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation
import os

/// Structured system logging for the Rise application using Apple's OSLog.
public enum AppLogger {
    private static let subsystem = AppConstants.bundleIdentifier

    public static let app = Logger(subsystem: subsystem, category: "App")
    public static let navigation = Logger(subsystem: subsystem, category: "Navigation")
    public static let data = Logger(subsystem: subsystem, category: "Data")
    public static let services = Logger(subsystem: subsystem, category: "Services")
    public static let ui = Logger(subsystem: subsystem, category: "UI")
}

/// Centralized lightweight logger wrapper for Rise.
public enum RiseLogger {
    public static func info(_ message: String) {
        #if DEBUG
            print("ℹ️ [Rise] \(message)")
        #endif
        AppLogger.app.info("\(message, privacy: .public)")
    }

    public static func warning(_ message: String) {
        #if DEBUG
            print("⚠️ [Rise] \(message)")
        #endif
        AppLogger.app.warning("\(message, privacy: .public)")
    }

    public static func error(_ message: String) {
        #if DEBUG
            print("❌ [Rise] \(message)")
        #endif
        AppLogger.app.error("\(message, privacy: .public)")
    }
}
