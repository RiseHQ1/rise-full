//
//  LanguageSettingsView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Choose the app display language with real-time UI localization.
public struct LanguageSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLanguage: AppLanguage = RiseLanguageManager.shared.currentLanguage

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: RiseL10n.tr("profile.language"),
            subtitle: RiseL10n.tr("profile.chooseLanguage")
        ) {
            VStack(spacing: 0) {
                ForEach(Array(AppLanguage.allCases.enumerated()), id: \.offset) { index, lang in
                    Button {
                        RiseHaptic.selection()
                        selectedLanguage = lang
                    } label: {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(lang.nativeName)
                                    .font(RiseTypography.subheadlineSemibold)
                                    .foregroundStyle(RiseColors.textPrimary)
                                Text(lang.englishName)
                                    .font(RiseTypography.caption)
                                    .foregroundStyle(RiseColors.textSecondary)
                            }
                            Spacer()
                            if selectedLanguage == lang {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(RiseColors.accentSecondary)
                            }
                        }
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if index < AppLanguage.allCases.count - 1 {
                        Divider().background(RiseColors.borderHairline)
                    }
                }
            }
            .padding(.horizontal, 14)
            .riseRichGlass(cornerRadius: RiseRadius.card)

            RisePrimaryButton(RiseL10n.tr("profile.saveLanguage"), iconName: "checkmark", style: .gold) {
                RiseHaptic.notification(.success)
                RiseLanguageManager.shared.setLanguage(selectedLanguage)
                dismiss()
            }
        }
        .onAppear {
            selectedLanguage = RiseLanguageManager.shared.currentLanguage
        }
    }
}

#Preview {
    LanguageSettingsView()
}
