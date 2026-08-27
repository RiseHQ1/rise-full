//
//  HomeGreetingView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Greeting block with time-based salutation and user first name.
public struct HomeGreetingView: View {
    public let greetingPrefix: String
    public let userName: String

    public init(greetingPrefix: String, userName: String) {
        self.greetingPrefix = greetingPrefix
        self.userName = userName
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(greetingPrefix)
                .font(RiseTypography.displaySoft)
                .foregroundStyle(RiseColors.textPrimary)

            Text(nameLine)
                .font(RiseTypography.displaySoft)

            Text("A new day. A fresh start.\nLet’s make it count.")
                .font(RiseTypography.body)
                .foregroundStyle(Color.white.opacity(0.72))
                .lineSpacing(2)
                .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var nameLine: AttributedString {
        var name = AttributedString("\(userName)!")
        name.foregroundColor = RiseColors.accentGold

        var wave = AttributedString(" 👋")
        wave.foregroundColor = RiseColors.textPrimary

        return name + wave
    }
}

#Preview("HomeGreetingView") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        HomeGreetingView(greetingPrefix: "Good morning,", userName: "John")
            .padding(RiseSpacing.md)
    }
}
