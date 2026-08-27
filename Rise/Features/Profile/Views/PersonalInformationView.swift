//
//  PersonalInformationView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Edit name and email for the signed-in Rise profile.
public struct PersonalInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var didSave = false

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Personal Information",
            subtitle: "Update the details that appear on your profile."
        ) {
            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                VStack(alignment: .leading, spacing: 12) {
                    RiseTextField(
                        placeholder: "Full name",
                        text: $name,
                        iconName: "person",
                        textInputAutocapitalization: .words
                    )
                    RiseTextField(
                        placeholder: "Email",
                        text: $email,
                        iconName: "envelope",
                        keyboardType: .emailAddress,
                        textInputAutocapitalization: .never
                    )
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.card)

                RisePrimaryButton("Save Changes", iconName: "checkmark", style: .gold) {
                    save()
                    dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                if didSave {
                    Text("Profile updated.")
                        .font(RiseTypography.footnoteMedium)
                        .foregroundStyle(RiseColors.accentSecondary)
                }
            }
        }
        .onAppear(perform: load)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: "saved_user_profile"),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
        else { return }
        name = profile.name
        email = profile.email ?? ""
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        UserProfileStore.shared.saveNameAndEmail(name: trimmedName, email: trimmedEmail)
        didSave = true
    }
}

#Preview {
    PersonalInformationView()
}
