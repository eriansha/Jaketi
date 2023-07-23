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
        // TODO: change to follow design system
        static let primary = Color(red: 0.173, green: 0.271, blue: 0.502)
        static let warning = Color(red: 0.95, green: 0.54, blue: 0)
        static let lightBlue = Color(red: 0.84, green: 0.91, blue: 0.97)
        static let green = Color(red: 0.26, green: 0.71, blue: 0.29)
        static let greyBg = Color(red: 242 / 255.0, green: 242 / 255.0, blue: 247 / 255.0)
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
        static let tibaDiPeron: String = "Tiba Di Peron"
        static let menit: String = "menit"
    }
}

