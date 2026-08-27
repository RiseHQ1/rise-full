//
//  RiseFeatureChrome.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Shared top chrome for pushed feature screens: back button + optional trailing action.
public struct RiseFeatureChrome<Trailing: View>: View {
    public let title: String?
    public let onBack: () -> Void
    public let trailing: () -> Trailing

    public init(
        title: String? = nil,
        onBack: @escaping () -> Void,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.title = title
        self.onBack = onBack
        self.trailing = trailing
    }

    public var body: some View {
        ZStack {
            if let title {
                Text(title)
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, RiseIconButtonMetrics.minimumHitTarget + 8)
                    .accessibilityAddTraits(.isHeader)
            }

            HStack {
                RiseIconButton(
                    iconName: "chevron.left",
                    accessibilityLabel: "Back",
                    style: .glass,
                    size: RiseIconButtonMetrics.standard,
                    action: onBack
                )

                Spacer(minLength: 0)

                // Don't force a fixed 44pt width — multi-button trailing (e.g. search + filter)
                // was getting crushed into a single hit target.
                trailing()
                    .frame(minHeight: RiseIconButtonMetrics.minimumHitTarget)
            }
        }
        .frame(minHeight: RiseIconButtonMetrics.minimumHitTarget)
    }
}

public extension RiseFeatureChrome where Trailing == EmptyView {
    init(title: String? = nil, onBack: @escaping () -> Void) {
        self.init(title: title, onBack: onBack) { EmptyView() }
    }
}

/// Maps `AppRoute` destinations to concrete Phase 2 feature screens.
public struct FeatureDestinationView: View {
    public let route: AppRoute

    public init(route: AppRoute) {
        self.route = route
    }

    public var body: some View {
        destination
            .riseWithStatusBarScrim()
            .riseEnableSwipeBack()
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var destination: some View {
        switch route {
        case let .needSomethingNow(moodTitle):
            NeedSomethingNowView(moodTitle: moodTitle)
        case .search:
            SearchView()
        case .motivationCategories:
            MotivationCategoriesView()
        case .dailyIntention:
            DailyIntentionView()
        case .intentionComplete:
            IntentionCompleteView()
        case .morningBoost:
            MorningBoostView()
        case .affirmations:
            AffirmationsView()
        case let .affirmationReader(initialId):
            AffirmationReaderView(initialId: initialId)
        case .breatheReset:
            BreatheResetView()
        case .eveningReflection:
            EveningReflectionView()
        case .journalHistory:
            JournalHistoryView()
        case .newJournalEntry:
            NewJournalEntryView()
        case let .journalEntryDetail(title):
            JournalEntryDetailView(title: title)
        case .saved:
            SavedView()
        case .savedMotivation:
            SavedMotivationView()
        case .notifications:
            NotificationsView()
        case .notificationPreferences:
            NotificationPreferencesView()
        case .reminderSchedule:
            ReminderScheduleView()
        case .languageSettings:
            LanguageSettingsView()
        case .personalInformation:
            PersonalInformationView()
        case .privacySecurity:
            PrivacySecurityView()
        case .backupRestore:
            BackupRestoreView()
        case .editStatusQuote:
            EditStatusQuoteView()
        case .risePlanEdit:
            RisePlanEditView()
        case .manageFocusAreas:
            ManageFocusAreasView()
        case .settings:
            NotificationPreferencesView()
        case .savedContent:
            SavedView()
        case .motivationDetail:
            MorningBoostView()
        case .focusAreaDetail:
            MotivationCategoriesView()
        case .paywall:
            RisePaywallView()
        case let .packDetail(title, category, durationDays, isPro, artworkAsset):
            RisePackDetailView(
                packTitle: title,
                packCategory: category,
                durationDays: durationDays,
                isPro: isPro,
                artworkAsset: artworkAsset
            )
        }
    }
}
