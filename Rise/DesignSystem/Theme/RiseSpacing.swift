//
//  RiseSpacing.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Standardized layout spacing scale for Rise.
/// Eliminates magic numbers across screens and components.
public enum RiseSpacing {
    /// 4 pt - Micro spacing (tag padding, inner icon gaps)
    public static let xxs: CGFloat = 4
    
    /// 8 pt - Extra small spacing (badge insets, tight item spacing)
    public static let xs: CGFloat = 8
    
    /// 12 pt - Small spacing (compact card elements, button icon spacing)
    public static let sm: CGFloat = 12
    
    /// 16 pt - Medium spacing (standard screen padding, card internal margin)
    public static let md: CGFloat = 16
    
    /// 24 pt - Large spacing (inter-card spacing, section headers)
    public static let lg: CGFloat = 24
    
    /// 32 pt - Extra large spacing (major section separation)
    public static let xl: CGFloat = 32
    
    /// 48 pt - Double extra large spacing (hero vertical margins, modal tops)
    public static let xxl: CGFloat = 48
    
    /// 64 pt - Triple extra large spacing (generous bottom clearance, hero spacing)
    public static let xxxl: CGFloat = 64
}
