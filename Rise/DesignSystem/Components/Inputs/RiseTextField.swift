//
//  RiseTextField.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Reusable dark glass text input field component with active warm gold (#F59E0B) focus border,
/// warm gold yellow insertion cursor, white password dots, and password visibility toggle.
public struct RiseTextField: View {
    let placeholder: String
    @Binding var text: String
    var iconName: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textInputAutocapitalization: TextInputAutocapitalization = .never
    var onChange: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    public init(
        placeholder: String,
        text: Binding<String>,
        iconName: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textInputAutocapitalization: TextInputAutocapitalization = .never,
        onChange: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.iconName = iconName
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.textInputAutocapitalization = textInputAutocapitalization
        self.onChange = onChange
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            if let iconName {
                Image(systemName: iconName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isFocused ? Color(hex: "#F59E0B") : RiseColors.textSecondary)
            }
            
            if isSecure && !isPasswordVisible {
                SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(RiseColors.textMuted))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .tint(Color(hex: "#F59E0B"))
                    .preferredColorScheme(.dark)
                    .focused($isFocused)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(textInputAutocapitalization)
                    .autocorrectionDisabled()
                    .onChange(of: text) { _, _ in
                        onChange?()
                    }
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(RiseColors.textMuted))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .tint(Color(hex: "#F59E0B"))
                    .preferredColorScheme(.dark)
                    .focused($isFocused)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(textInputAutocapitalization)
                    .autocorrectionDisabled()
                    .onChange(of: text) { _, _ in
                        onChange?()
                    }
            }
            
            if isSecure {
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(hex: "#100C24").opacity(0.82))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(
                    isFocused
                        ? Color(hex: "#F59E0B")
                        : RiseColors.borderSubtle.opacity(0.6),
                    lineWidth: isFocused ? 1.5 : 1.0
                )
        }
    }
}

#Preview("RiseTextField") {
    ZStack {
        RiseColors.backgroundPrimary
            .ignoresSafeArea()
        
        VStack(spacing: 16) {
            RiseTextField(
                placeholder: "Full name",
                text: .constant("Kwame"),
                iconName: "person"
            )
            
            RiseTextField(
                placeholder: "Create password",
                text: .constant("Secret123!"),
                iconName: "lock",
                isSecure: true
            )
        }
        .padding()
    }
}
