//
//  RiseInteractivePopGesture.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI
import UIKit

/// Re-enables the native edge swipe-back gesture when the system navigation bar is hidden.
///
/// SwiftUI’s `.toolbar(.hidden, for: .navigationBar)` / `.navigationBarHidden(true)`
/// leaves `UINavigationController.interactivePopGestureRecognizer` disabled. This
/// bridge turns it back on for every pushed Rise screen that uses custom chrome.
struct RiseInteractivePopGestureEnabler: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = ProbeView()
        view.coordinator = context.coordinator
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context _: Context) {
        (uiView as? ProbeView)?.enableInteractivePopIfNeeded()
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        weak var navigationController: UINavigationController?

        func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
            (navigationController?.viewControllers.count ?? 0) > 1
        }

        /// Keep edge-swipe working alongside vertical `ScrollView` pans.
        func gestureRecognizer(
            _: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
        ) -> Bool {
            true
        }

        /// Prefer the edge-swipe over competing pan gestures near the leading edge.
        func gestureRecognizer(
            _: UIGestureRecognizer,
            shouldBeRequiredToFailBy _: UIGestureRecognizer
        ) -> Bool {
            false
        }
    }

    private final class ProbeView: UIView {
        weak var coordinator: Coordinator?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            enableInteractivePopIfNeeded()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            enableInteractivePopIfNeeded()
        }

        func enableInteractivePopIfNeeded() {
            guard let navigationController = nearestNavigationController() else { return }
            guard let popGesture = navigationController.interactivePopGestureRecognizer else { return }

            coordinator?.navigationController = navigationController
            popGesture.isEnabled = true
            popGesture.delegate = coordinator
        }

        private func nearestNavigationController() -> UINavigationController? {
            var responder: UIResponder? = self
            while let current = responder {
                if let viewController = current as? UIViewController {
                    if let navigationController = viewController.navigationController {
                        return navigationController
                    }
                }
                responder = current.next
            }

            var view: UIView? = superview
            while let current = view {
                if let nextResponder = current.next as? UIViewController,
                   let navigationController = nextResponder.navigationController
                {
                    return navigationController
                }
                view = current.superview
            }

            return nil
        }
    }
}

public extension View {
    /// Enables native iOS edge swipe-to-pop while using custom Rise back chrome.
    func riseEnableSwipeBack() -> some View {
        background {
            RiseInteractivePopGestureEnabler()
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        }
    }

    /// Leading-edge swipe dismiss for `fullScreenCover` / modal screens (not on a nav stack).
    func riseEdgeSwipeToDismiss(
        edgeWidth: CGFloat = 28,
        minimumTranslation: CGFloat = 90
    ) -> some View {
        modifier(
            RiseEdgeSwipeDismissModifier(
                edgeWidth: edgeWidth,
                minimumTranslation: minimumTranslation
            )
        )
    }
}

private struct RiseEdgeSwipeDismissModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    let edgeWidth: CGFloat
    let minimumTranslation: CGFloat

    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onEnded { value in
                    let startedAtEdge = value.startLocation.x <= edgeWidth
                    let swipedRight = value.translation.width >= minimumTranslation
                    let mostlyHorizontal = abs(value.translation.width) > abs(value.translation.height)
                    guard startedAtEdge, swipedRight, mostlyHorizontal else { return }
                    RiseHaptic.impact(.light)
                    dismiss()
                }
        )
    }
}
