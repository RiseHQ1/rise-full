//
//  AudioServiceProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Protocol for ambient soundscapes, breathing audio cues, and meditation playback.
public protocol AudioServiceProtocol: Sendable {
    func playSoundEffect(named name: String)
    func startAmbientSound(named name: String, loop: Bool)
    func stopAmbientSound()
    func pause()
    func resume()
}
