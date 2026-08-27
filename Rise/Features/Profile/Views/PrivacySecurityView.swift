//
//  PrivacySecurityView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Privacy and security controls for the Rise account.
public struct PrivacySecurityView: View {
    @State private var faceIDLock = false
    @State private var hideJournalPreviews = true
    @State private var analyticsSharing = false
    @State private var personalizedContent = true
    @State private var showExportShare = false
    @State private var showDeleteConfirm = false
    @State private var showDeleteSuccess = false

    public init() {}

    private var exportDataText: String {
        let entriesCount = JournalStore.shared.entries.count
        let savedCount = SavedContentStore.shared.items.count
        return """
        Rise Account Data Export
        Name: \(UserProfileStore.shared.name)
        Email: \(UserProfileStore.shared.email)
        Member Since: \(UserProfileStore.shared.memberSince)
        Status Quote: \(UserProfileStore.shared.statusQuote)
        Active Focus Areas: \(UserProfileStore.shared.activeFocusAreaIds.joined(separator: ", "))
        Total Journal Entries: \(entriesCount)
        Total Saved Items: \(savedCount)

        Export Date: \(Date().formatted(date: .abbreviated, time: .shortened))
        """
    }

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Privacy & Security",
            subtitle: "Manage how your data stays protected."
        ) {
            VStack(spacing: 10) {
                toggleRow(
                    icon: "faceid",
                    title: "Lock with Face ID",
                    subtitle: "Require Face ID to open Rise.",
                    isOn: $faceIDLock
                )
                toggleRow(
                    icon: "eye.slash",
                    title: "Hide journal previews",
                    subtitle: "Keep entry snippets private on Home.",
                    isOn: $hideJournalPreviews
                )
                toggleRow(
                    icon: "chart.xyaxis.line",
                    title: "Share anonymous analytics",
                    subtitle: "Help improve Rise without personal data.",
                    isOn: $analyticsSharing
                )
                toggleRow(
                    icon: "sparkles",
                    title: "Personalized content",
                    subtitle: "Tailor quotes and prompts to your focus.",
                    isOn: $personalizedContent
                )
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)

            VStack(alignment: .leading, spacing: 10) {
                Text("Your data")
                    .font(RiseTypography.footnoteSemibold)
                    .foregroundStyle(RiseColors.textSecondary)

                Button {
                    showExportShare = true
                } label: {
                    infoRow(icon: "doc.text", title: "Export my data", subtitle: "Request a copy of your journal & profile.")
                }
                .buttonStyle(.plain)

                Button {
                    showDeleteConfirm = true
                } label: {
                    infoRow(icon: "trash", title: "Delete account data", subtitle: "Permanently remove local Rise data.")
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)
            .onAppear(perform: load)
            .onChange(of: faceIDLock) { _, _ in persist() }
            .onChange(of: hideJournalPreviews) { _, _ in persist() }
            .onChange(of: analyticsSharing) { _, _ in persist() }
            .onChange(of: personalizedContent) { _, _ in persist() }
        }
        .sheet(isPresented: $showExportShare) {
            RiseShareSheet(items: [exportDataText])
        }
        .alert("Delete Account Data?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete Data", role: .destructive) {
                UserDefaults.standard.removeObject(forKey: "saved_user_profile")
                UserDefaults.standard.removeObject(forKey: "rise_journal_entries_v1")
                JournalStore.shared.loadEntries()
                showDeleteSuccess = true
            }
        } message: {
            Text("This will reset your local profile details and journal entries. This action cannot be undone.")
        }
        .alert("Data Reset", isPresented: $showDeleteSuccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your local data has been reset to defaults.")
        }
    }

    private func toggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            ProfileSettingRow(icon: icon, title: title, subtitle: subtitle)
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(RiseColors.accentSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                .fill(RiseColors.surfaceInset.opacity(0.65))
        )
    }

    private func infoRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 12) {
            ProfileSettingRow(icon: icon, title: title, subtitle: subtitle)
            Image(systemName: "chevron.right")
                .font(RiseTypography.captionSemibold)
                .foregroundStyle(RiseColors.textMuted)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                .fill(RiseColors.surfaceInset.opacity(0.65))
        )
    }

    private func load() {
        let defaults = UserDefaults.standard
        faceIDLock = defaults.bool(forKey: "privacy_face_id")
        hideJournalPreviews = defaults.object(forKey: "privacy_hide_journal") as? Bool ?? true
        analyticsSharing = defaults.bool(forKey: "privacy_analytics")
        personalizedContent = defaults.object(forKey: "privacy_personalized") as? Bool ?? true
    }

    private func persist() {
        let defaults = UserDefaults.standard
        defaults.set(faceIDLock, forKey: "privacy_face_id")
        defaults.set(hideJournalPreviews, forKey: "privacy_hide_journal")
        defaults.set(analyticsSharing, forKey: "privacy_analytics")
        defaults.set(personalizedContent, forKey: "privacy_personalized")

        UserProfileStore.shared.faceIDLock = faceIDLock
        UserProfileStore.shared.hideJournalPreviews = hideJournalPreviews
        UserProfileStore.shared.analyticsSharing = analyticsSharing
        UserProfileStore.shared.personalizedContent = personalizedContent
    }
}

#Preview {
    PrivacySecurityView()
}
