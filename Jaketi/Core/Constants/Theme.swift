//
//  Theme.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import Foundation
import SwiftUI

struct Theme { private init() {} }

// MARK: Colors
extension Theme {
    struct Colors {
        // Base
        static let blue = Color("Blue")
        static let orange = Color("Orange")
        static let green = Color("Green")
        
        // MRT Original
        static let MRTBlue = Color("MRTBlue")
        static let MRTGreen = Color("MRTGreen")
        
        // Shape
        static let card = Color("Card")
        static let cBArrow = Color("CBArrow").opacity(0.6)
        static let divider = Color("Divider").opacity(0.25)
        static let line = Color("Line")
        
        // Field
        static let comboBox = Color("ComboBox")
        static let searchField = Color("SearchField").opacity(0.12)
        
        // Label
        static let label = Color("Label")
        static let labelInactive = Color("LabelInactive").opacity(0.3)
        static let whiteLabel = Color("WhiteLabel")
        
        // Highlighted
        static let highlighted = Color("Highlighted")
        static let highlightedLabel = Color("HighlightedLabel")
        static let highlightedLabel2 = Color("HighlightedLabel2").opacity(0.5)
        static let highlightedTag = Color("HighlightedTag")
        
        // Background
        static let background = Color("Background")
        static let backgroundSheet = Color("BackgroundSheet")
    }
}

// MARK: Font Size
extension Theme {
    struct FontSize {
        // TODO: change to follow design system
        static let base = Font.system(size: 56)
    }
}

// MARK: Corner Radius
extension Theme {
    struct CornerRadius {
        // TODO: change to follow design system
        static let large: Double = 16
    }
}


extension Theme {
    struct Title{
        static let schedule: String = "Schedule"
    }
}

extension Theme {
    struct Strings{
        static let tibaDiPeron: String = "Arrived"
        static let menit: String = "minutes"
    }
}

