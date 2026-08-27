//
//  SoundscapeType.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation

/// Available procedural and hybrid ambient soundscapes.
public enum SoundscapeType: String, CaseIterable, Identifiable, Hashable, Sendable {
    case none
    case zenBell
    case binauralAlpha
    case pinkRain
    case brownHush
    case solfeggio528
    case forestDawn
    case campfire

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .none: return "Mute"
        case .zenBell: return "Zen Singing Bowl"
        case .binauralAlpha: return "Alpha Wave (8Hz)"
        case .pinkRain: return "Gentle Rain"
        case .brownHush: return "Deep Ocean"
        case .solfeggio528: return "528Hz Solfeggio"
        case .forestDawn: return "Forest Dawn"
        case .campfire: return "Cozy Campfire"
        }
    }

    public var subtitle: String {
        switch self {
        case .none: return "Silent session"
        case .zenBell: return "Resonant harmonic bell cues"
        case .binauralAlpha: return "Calm focus & relaxation"
        case .pinkRain: return "Warm soothing rainfall"
        case .brownHush: return "Deep ocean surf ambiance"
        case .solfeggio528: return "Harmonic clarity frequency"
        case .forestDawn: return "Fresh morning breeze & birds"
        case .campfire: return "Warm crackling fire & embers"
        }
    }

    public var systemIcon: String {
        switch self {
        case .none: return "speaker.slash.fill"
        case .zenBell: return "bell.fill"
        case .binauralAlpha: return "waveform.path.ecg"
        case .pinkRain: return "cloud.rain.fill"
        case .brownHush: return "water.waves"
        case .solfeggio528: return "sparkles"
        case .forestDawn: return "leaf.fill"
        case .campfire: return "flame.fill"
        }
    }

    /// Map server-recommended soundscape string to native Swift enum.
    public static func from(serverKey: String?) -> SoundscapeType {
        guard let serverKey = serverKey?.uppercased() else { return .zenBell }
        switch serverKey {
        case "FOREST_DAWN": return .forestDawn
        case "OCEAN_TIDES", "BROWN_HUSH": return .brownHush
        case "CELESTIAL_RAIN", "PINK_RAIN": return .pinkRain
        case "DEEP_SPACE", "BINAURAL_ALPHA": return .binauralAlpha
        case "SOLAR_CHIMES", "ZEN_BELL": return .zenBell
        case "MOUNTAIN_WIND", "SOLFEGGIO_528": return .solfeggio528
        default: return .zenBell
        }
    }
}
