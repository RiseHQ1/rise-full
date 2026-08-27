//
//  NotificationsView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// In-app notifications inbox — streak, intention, motivation, and reminder updates.
public struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var state = NotificationsState()

    public init() {}

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Notifications", onBack: { dismiss() })

                    HStack(alignment: .firstTextBaseline) {
                        Text(
                            state.unreadCount > 0
                                ? "\(state.unreadCount) new update\(state.unreadCount == 1 ? "" : "s") for your Rise journey."
                                : "You’re all caught up. Keep rising."
                        )
                        .font(RiseTypography.body)
                        .foregroundStyle(RiseColors.textSecondary)

                        Spacer(minLength: 8)

                        Button("Mark all read") {
                            RiseHaptic.notification(.success)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                state.markAllAsRead()
                            }
                        }
                        .font(RiseTypography.footnoteSemibold)
                        .foregroundStyle(
                            state.unreadCount > 0
                                ? RiseColors.accentPrimary
                                : RiseColors.textMuted
                        )
                        .disabled(state.unreadCount == 0)
                        .accessibilityLabel("Mark all notifications as read")
                    }

                    filterRow

                    if state.visibleItems.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(state.visibleItems) { item in
                                notificationRow(item)
                            }
                        }
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }

    private var filterRow: some View {
        HStack(spacing: 8) {
            ForEach(NotificationsState.Filter.allCases) { filter in
                RiseTag(filter.title, isSelected: state.filter == filter) {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        state.selectFilter(filter)
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }

    private func notificationRow(_ item: NotificationsState.Item) -> some View {
        Button {
            RiseHaptic.impact(.light)
            withAnimation(.easeInOut(duration: 0.18)) {
                state.markAsRead(item)
            }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: item.kind.accentHex).opacity(0.22))
                        .frame(width: 42, height: 42)
                    Image(systemName: item.kind.systemIcon)
                        .font(RiseTypography.calloutSemibold)
                        .foregroundStyle(Color(hex: item.kind.accentHex))
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(item.title)
                            .font(RiseTypography.subheadlineBold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer(minLength: 4)

                        Text(item.timeLabel)
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)
                    }

                    Text(item.body)
                        .font(RiseTypography.footnote)
                        .foregroundStyle(RiseColors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if item.isUnread {
                    Circle()
                        .fill(RiseColors.accentSecondary)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                }
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)
            .overlay(alignment: .leading) {
                if item.isUnread {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(RiseColors.accentSecondary)
                        .frame(width: 3)
                        .padding(.vertical, 14)
                        .padding(.leading, 2)
                }
            }
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel(
            "\(item.title). \(item.body). \(item.isUnread ? "Unread" : "Read"). \(item.timeLabel)"
        )
        .accessibilityHint(item.isUnread ? "Double tap to mark as read." : "Already read.")
    }

    private var emptyState: some View {
        RiseEmptyState(
            iconName: "bell.slash",
            title: state.filter == .unread ? "No unread notifications" : "No notifications yet",
            message: state.filter == .unread
                ? "You’re caught up. Switch to All to review earlier updates."
                : "When Rise has something for you, it’ll show up here."
        )
    }
}

#Preview("NotificationsView") {
    NotificationsView()
}
