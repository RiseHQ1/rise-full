//
//  RiseAudioEngine.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import AVFoundation
import Foundation
import Observation

/// High-performance procedural and hybrid ambient audio engine for Rise.
@Observable
@MainActor
public final class RiseAudioEngine {
    public static let shared = RiseAudioEngine()

    public var activeSoundscape: SoundscapeType = .binauralAlpha
    public var isPlaying: Bool = false
    public var volume: Float = 0.7 {
        didSet {
            engineSourceNode?.volume = volume
        }
    }

    private var audioEngine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private var engineSourceNode: AVAudioMixerNode?

    /// Synthesizer runtime state (accessed in audio render block via non-reallocating pointers/structs)
    private final class SynthState: @unchecked Sendable {
        var sampleRate: Float = 44100.0
        var phase: Float = 0.0
        var phase2: Float = 0.0
        var phaseMod: Float = 0.0
        var chimeEnvelope: Float = 0.0
        var chimePhase: Float = 0.0
        var brownNoiseAccumulator: Float = 0.0
        var activeType: SoundscapeType = .binauralAlpha
        var isChimeActive: Bool = false
    }

    private let synthState = SynthState()

    public init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("[RiseAudioEngine] AudioSession setup error: \(error)")
        }
    }

    /// Play a gentle harmonic chime for breath transitions or completions.
    public func playChime(frequency _: Float = 528.0) {
        synthState.chimePhase = 0.0
        synthState.chimeEnvelope = 1.0
        synthState.isChimeActive = true

        if !isPlaying {
            startSoundscape(.zenBell)
        }
    }

    /// Start playing continuous ambient soundscape.
    public func startSoundscape(_ soundscape: SoundscapeType) {
        activeSoundscape = soundscape
        synthState.activeType = soundscape

        if soundscape == .none {
            stopSoundscape()
            return
        }

        if audioEngine == nil || !(audioEngine?.isRunning ?? false) {
            setupEngine()
        }

        isPlaying = true
    }

    /// Stop playing ambient soundscape.
    public func stopSoundscape() {
        isPlaying = false
        audioEngine?.stop()
    }

    private func setupEngine() {
        let engine = AVAudioEngine()
        let mainMixer = engine.mainMixerNode
        let outputFormat = mainMixer.outputFormat(forBus: 0)
        let sampleRate = Float(outputFormat.sampleRate > 0 ? outputFormat.sampleRate : 44100.0)
        synthState.sampleRate = sampleRate

        let state = synthState

        // Real-time pure math synthesis block (zero allocations)
        let node = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let dt = 1.0 / state.sampleRate

            for frame in 0 ..< Int(frameCount) {
                var sampleL: Float = 0.0
                var sampleR: Float = 0.0

                switch state.activeType {
                case .none:
                    sampleL = 0.0
                    sampleR = 0.0

                case .zenBell:
                    if state.isChimeActive && state.chimeEnvelope > 0.001 {
                        let fundamental = sin(state.chimePhase * 2.0 * .pi * 528.0)
                        let overtone1 = 0.5 * sin(state.chimePhase * 2.0 * .pi * 1056.0)
                        let overtone2 = 0.25 * sin(state.chimePhase * 2.0 * .pi * 1584.0)
                        let bell = (fundamental + overtone1 + overtone2) * state.chimeEnvelope * 0.35
                        sampleL += bell
                        sampleR += bell

                        state.chimePhase += dt
                        state.chimeEnvelope *= 0.99975 // exponential decay
                    } else {
                        state.isChimeActive = false
                    }

                case .binauralAlpha:
                    // 432Hz carrier + 8Hz alpha wave (432Hz left, 440Hz right)
                    let carrier: Float = 432.0
                    let beat: Float = 8.0
                    sampleL = 0.18 * sin(state.phase * 2.0 * .pi * carrier)
                    sampleR = 0.18 * sin(state.phase2 * 2.0 * .pi * (carrier + beat))

                    state.phase += dt
                    state.phase2 += dt
                    if state.phase > 1.0 {
                        state.phase -= 1.0
                    }
                    if state.phase2 > 1.0 {
                        state.phase2 -= 1.0
                    }

                case .pinkRain:
                    // Voss-McCartney approximation of rainfall noise
                    let white = Float.random(in: -1.0 ... 1.0)
                    state.brownNoiseAccumulator = (state.brownNoiseAccumulator + (0.05 * white)) / 1.05
                    let rain = state.brownNoiseAccumulator * 0.4
                    sampleL = rain + Float.random(in: -0.04 ... 0.04)
                    sampleR = rain + Float.random(in: -0.04 ... 0.04)

                case .brownHush:
                    // Deep low-pass filtered ocean noise
                    let white = Float.random(in: -1.0 ... 1.0)
                    state.brownNoiseAccumulator = (state.brownNoiseAccumulator + (0.02 * white)) / 1.02
                    let surf = state.brownNoiseAccumulator * 0.6
                    sampleL = surf
                    sampleR = surf

                case .solfeggio528:
                    // Pure 528Hz Miracle tone
                    let tone = 0.22 * sin(state.phase * 2.0 * .pi * 528.0)
                    sampleL = tone
                    sampleR = tone
                    state.phase += dt
                    if state.phase > 1.0 {
                        state.phase -= 1.0
                    }

                case .forestDawn:
                    // Harmonic light breeze + soft ambient chirps
                    let breeze = sin(state.phaseMod * 2.0 * .pi * 0.2) * 0.08
                    state.phaseMod += dt

                    let white = Float.random(in: -1.0 ... 1.0)
                    state.brownNoiseAccumulator = (state.brownNoiseAccumulator + (0.03 * white)) / 1.03
                    sampleL = state.brownNoiseAccumulator * 0.25 + breeze
                    sampleR = state.brownNoiseAccumulator * 0.25 + breeze
                }

                // Mix active chime over soundscape if present
                if state.isChimeActive && state.chimeEnvelope > 0.001 {
                    let fundamental = sin(state.chimePhase * 2.0 * .pi * 528.0)
                    let bell = fundamental * state.chimeEnvelope * 0.3
                    sampleL += bell
                    sampleR += bell
                    state.chimePhase += dt
                    state.chimeEnvelope *= 0.9998
                }

                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = buffer.mDataByteSize == MemoryLayout<Float>.size * 2
                        ? (frame % 2 == 0 ? sampleL : sampleR)
                        : sampleL
                }
            }

            return noErr
        }

        engine.attach(node)
        engine.connect(node, to: mainMixer, format: outputFormat)

        do {
            try engine.start()
            audioEngine = engine
            sourceNode = node
            engineSourceNode = mainMixer
            mainMixer.volume = volume
        } catch {
            print("[RiseAudioEngine] Start engine error: \(error)")
        }
    }
}
