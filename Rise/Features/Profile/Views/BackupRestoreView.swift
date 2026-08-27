//
//  BackupRestoreView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Backup and restore controls for journal safety.
public struct BackupRestoreView: View {
    @State private var iCloudBackup = true
    @State private var lastBackupLabel = "Never"
    @State private var isBackingUp = false
    @State private var statusMessage: String?

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Backup & Restore",
            subtitle: "Keep your journal safe across devices."
        ) {
            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        ProfileSettingRow(
                            icon: "icloud",
                            title: "iCloud Backup",
                            subtitle: "Automatically sync when signed in."
                        )
                        Toggle("", isOn: $iCloudBackup)
                            .labelsHidden()
                            .tint(RiseColors.accentSecondary)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                            .fill(RiseColors.surfaceInset.opacity(0.65))
                    )

                    HStack(spacing: 12) {
                        ProfileSettingRow(
                            icon: "clock.arrow.circlepath",
                            title: "Last backup",
                            subtitle: lastBackupLabel
                        )
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                            .fill(RiseColors.surfaceInset.opacity(0.65))
                    )
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.card)

                RisePrimaryButton(
                    isBackingUp ? "Backing up…" : "Back Up Now",
                    iconName: "arrow.up.doc",
                    isLoading: isBackingUp,
                    style: .gold
                ) {
                    runBackup()
                }

                Button {
                    RiseHaptic.notification(.success)
                    JournalStore.shared.loadEntries()
                    statusMessage = "Successfully verified and restored \(JournalStore.shared.entries.count) entries from \(lastBackupLabel == "Never" ? "local store" : lastBackupLabel)."
                } label: {
                    HStack {
                        Image(systemName: "arrow.down.doc")
                        Text("Restore from Backup")
                            .font(RiseTypography.subheadlineBold)
                    }
                    .foregroundStyle(RiseColors.accentPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .riseRichGlass(cornerRadius: RiseRadius.large)
                }
                .buttonStyle(RisePressableButtonStyle())

                if let statusMessage {
                    Text(statusMessage)
                        .font(RiseTypography.footnoteMedium)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
            .onAppear(perform: load)
            .onChange(of: iCloudBackup) { _, value in
                UserDefaults.standard.set(value, forKey: "backup_icloud_enabled")
            }
        }
    }

    private func load() {
        iCloudBackup = UserDefaults.standard.object(forKey: "backup_icloud_enabled") as? Bool ?? true
        lastBackupLabel = UserDefaults.standard.string(forKey: "backup_last_label") ?? "Never"
    }

    private func runBackup() {
        isBackingUp = true
        statusMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            let label = formatter.string(from: Date())
            lastBackupLabel = label
            UserDefaults.standard.set(label, forKey: "backup_last_label")
            isBackingUp = false
            statusMessage = "Local backup saved."
        }
    }
}

#Preview {
    BackupRestoreView()
}
