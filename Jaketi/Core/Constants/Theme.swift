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
        static let primary = Color.blue
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
