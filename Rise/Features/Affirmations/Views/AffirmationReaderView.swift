//
//  AffirmationReaderView.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Full-screen affirmation reader — vertical paging between items.
/// Pushed on the tab `NavigationStack` so native edge swipe-back works.
public struct AffirmationReaderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let initialId: UUID
    private let session = AffirmationsReaderSession.shared

    @State private var currentId: UUID?
    @State private var sharePayload: RiseSharePayload?
    @State private var savePulse = 0

    public init(initialId: UUID) {
        self.initialId = initialId
        _currentId = State(initialValue: initialId)
    }

    private var items: [AffirmationsState.Item] {
        session.items
    }

    private var activeId: UUID {
        currentId ?? initialId
    }

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            AmbientGlow()

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(items) { item in
                        page(for: item)
                            .containerRelativeFrame(.vertical)
                            .id(item.id)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentId)
            .scrollBounceBehavior(.basedOnSize)

            VStack(spacing: 0) {
                chrome
                Spacer()
                if items.count > 1, !reduceMotion {
                    swipeHint
                        .padding(.bottom, 28)
                }
            }
            .padding(.horizontal, RiseSpacing.md)
        }
        .sheet(item: $sharePayload) { payload in
            RiseShareSheet(payload: payload)
        }
        .onAppear {
            let startId = session.initialId ?? initialId
            if let currentId, items.contains(where: { $0.id == currentId }) {
                return
            }
            currentId = items.contains(where: { $0.id == startId })
                ? startId
                : items.first?.id
        }
        .onDisappear {
            AffirmationsReaderSession.shared.clear()
        }
        .onChange(of: currentId) { _, _ in
            guard !reduceMotion else { return }
            RiseHaptic.selection()
        }
        .navigationBarHidden(true)
    }

    private var chrome: some View {
        RiseFeatureChrome(onBack: { dismiss() }) {
            HStack(spacing: 8) {
                RiseIconButton(
                    iconName: session.isSaved(activeId) ? "bookmark.fill" : "bookmark",
                    accessibilityLabel: "Save",
                    style: .glass,
                    bounceTrigger: savePulse
                ) {
                    session.toggleSaved(activeId)
                    savePulse += 1
                }

                RiseIconButton(
                    iconName: "square.and.arrow.up",
                    accessibilityLabel: "Share",
                    style: .glass
                ) {
                    if let item = items.first(where: { $0.id == activeId }) {
                        sharePayload = RiseSharePayload(text: item.text)
                    }
                }
            }
        }
        .padding(.top, 8)
    }

    private func page(for item: AffirmationsState.Item) -> some View {
        VStack(spacing: RiseSpacing.lg) {
            Spacer(minLength: 72)

            HStack(spacing: 8) {
                Image(systemName: item.systemIcon)
                    .font(RiseTypography.captionBold)
                Text(item.category.title.uppercased())
                    .font(RiseTypography.captionBold)
                    .tracking(0.8)
            }
            .foregroundStyle(Color(hex: item.accentHex))
            .padding(.horizontal, 14)
            .frame(height: 32)
            .background(Capsule().fill(Color(hex: item.accentHex).opacity(0.16)))
            .overlay {
                Capsule().stroke(Color(hex: item.accentHex).opacity(0.45), lineWidth: 1)
            }

            Text(item.text)
                .font(RiseTypography.display)
                .foregroundStyle(RiseColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, RiseSpacing.md)
                .minimumScaleFactor(0.85)
                .opacity(activeId == item.id ? 1 : 0.78)
                .scaleEffect(activeId == item.id ? 1 : 0.985)
                .animation(
                    RiseAnimations.preferred(RiseAnimations.riseSettle, reduceMotion: reduceMotion),
                    value: activeId
                )
                .accessibilityLabel(item.text)
                .accessibilityAddTraits(.isStaticText)

            Text(item.tagline)
                .font(RiseTypography.subheadline)
                .foregroundStyle(RiseColors.textSecondary)

            Spacer()

            Text(pageLabel(for: item))
                .font(RiseTypography.footnoteSemibold)
                .foregroundStyle(RiseColors.textMuted)
                .padding(.bottom, 64)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func pageLabel(for item: AffirmationsState.Item) -> String {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return "" }
        return "\(index + 1) of \(items.count)"
    }

    private var swipeHint: some View {
        HStack(spacing: 6) {
            Image(systemName: "chevron.up")
                .font(RiseTypography.microBold)
            Text("Swipe for next")
                .font(RiseTypography.captionSemibold)
        }
        .foregroundStyle(RiseColors.textMuted)
        .opacity(0.85)
        .allowsHitTesting(false)
    }
}

private struct AmbientGlow: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [RiseColors.accentPrimary.opacity(0.22), .clear],
                center: .top,
                startRadius: 20,
                endRadius: 280
            )
            RadialGradient(
                colors: [RiseColors.accentSecondary.opacity(0.10), .clear],
                center: .bottomTrailing,
                startRadius: 10,
                endRadius: 260
            )
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

#Preview {
    let state = AffirmationsState()
    AffirmationsReaderSession.shared.prepare(items: state.items, initialId: state.items[0].id)
    return AffirmationReaderView(initialId: state.items[0].id)
}
