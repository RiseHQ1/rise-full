//
//  View+Extensions.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI
import UIKit

public extension View {
    /// Dismiss the active software keyboard.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
