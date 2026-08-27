//
//  RiseSearchField.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Shared search field used by Search, Journal History, and Discover (display mode).
public struct RiseSearchField: View {
    public let placeholder: String
    @Binding public var text: String
    public var isInteractive: Bool
    public var onSubmit: (() -> Void)?

    public init(
        placeholder: String,
        text: Binding<String>,
        isInteractive: Bool = true,
        onSubmit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        _text = text
        self.isInteractive = isInteractive
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(RiseTypography.calloutSemibold)
                .foregroundStyle(RiseColors.textSecondary)

            if isInteractive {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(RiseColors.textMuted))
                    .font(RiseTypography.subheadline)
                    .foregroundStyle(RiseColors.textPrimary)
                    .tint(RiseColors.accentSecondary)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit { onSubmit?() }

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(RiseColors.textMuted)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                }
            } else {
                Text(placeholder)
                    .font(RiseTypography.footnoteMedium)
                    .foregroundStyle(RiseColors.textMuted)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background {
            RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous)
                .fill(RiseColors.surfaceField.opacity(0.72))
        }
        .overlay {
            RoundedRectangle(cornerRadius: RiseRadius.extraLarge, style: .continuous)
                .stroke(RiseColors.borderHairline, lineWidth: 1)
        }
        .allowsHitTesting(isInteractive)
        .accessibilityAddTraits(isInteractive ? [] : [.isButton])
        .accessibilityLabel(isInteractive ? "Search" : placeholder)
        .accessibilityIdentifier(RiseAccessibilityID.searchField)
    }
}

#Preview {
    @Previewable @State var query = ""
    RiseSearchField(placeholder: "Search…", text: $query)
        .padding()
        .background(RiseColors.backgroundAmbient)
}
