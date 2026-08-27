//
//  RiseMotionModifiers.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Staggered first-appearance: fade + slight rise + soft scale-in.
public struct RiseAppearModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public var delay: Double
    @State private var isVisible = false

    public init(delay: Double = 0) {
        self.delay = delay
    }

    public func body(content: Content) -> some View {
        content
            .opacity(isVisible || reduceMotion ? 1 : 0)
            .offset(y: isVisible || reduceMotion ? 0 : 14)
            .scaleEffect(isVisible || reduceMotion ? 1 : 0.97)
            .onAppear {
                guard !isVisible else { return }
                guard !reduceMotion else {
                    isVisible = true
                    return
                }
                withAnimation(RiseAnimations.riseIn.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

/// One-shot gold success burst for milestone icons (e.g. Intention complete).
public struct RiseSuccessBurstModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isArmed = false

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isArmed || reduceMotion ? 1 : 0.72)
            .opacity(isArmed || reduceMotion ? 1 : 0)
            .shadow(
                color: RiseColors.accentGold.opacity(isArmed && !reduceMotion ? 0.55 : 0.25),
                radius: isArmed && !reduceMotion ? 22 : 10
            )
            .onAppear {
                guard !isArmed else { return }
                guard !reduceMotion else {
                    isArmed = true
                    return
                }
                withAnimation(RiseAnimations.goldPulse) {
                    isArmed = true
                }
            }
    }
}

/// Soft crossfade + vertical drift used when affirmation reader pages change.
public struct RisePageCrossfadeModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public var identity: AnyHashable

    public func body(content: Content) -> some View {
        content
            .id(identity)
            .transition(
                reduceMotion
                    ? .opacity
                    : .asymmetric(
                        insertion: .opacity.combined(with: .offset(y: 18)),
                        removal: .opacity.combined(with: .offset(y: -12))
                    )
            )
            .animation(
                RiseAnimations.preferred(RiseAnimations.riseSettle, reduceMotion: reduceMotion),
                value: identity
            )
    }
}

/// Bounce feedback for bookmark / favorite toggles when motion is allowed.
public struct RiseToggleBounceModifier<Trigger: Equatable>: ViewModifier {
    public var trigger: Trigger

    public func body(content: Content) -> some View {
        content.symbolEffect(.bounce, value: trigger)
    }
}

/// Applies symbol bounce only when an explicit tap counter is provided.
public struct RiseOptionalSymbolBounce: ViewModifier {
    public var trigger: Int?

    public func body(content: Content) -> some View {
        if let trigger {
            content.symbolEffect(.bounce, value: trigger)
        } else {
            content
        }
    }
}

public extension View {
    /// Staggered Rise entrance (opacity + rise + soft scale).
    func riseAppear(delay: Double = 0) -> some View {
        modifier(RiseAppearModifier(delay: delay))
    }

    /// Gold success burst for milestone icons.
    func riseSuccessBurst() -> some View {
        modifier(RiseSuccessBurstModifier())
    }

    /// Soft page crossfade keyed by identity (affirmation reader, etc.).
    func risePageCrossfade(id identity: some Hashable) -> some View {
        modifier(RisePageCrossfadeModifier(identity: AnyHashable(identity)))
    }

    /// Bounce feedback for bookmark / favorite toggles when motion is allowed.
    /// Prefer a tap counter so scroll-driven icon swaps do not bounce.
    func riseToggleBounce(trigger: some Equatable) -> some View {
        modifier(RiseToggleBounceModifier(trigger: trigger))
    }
}
