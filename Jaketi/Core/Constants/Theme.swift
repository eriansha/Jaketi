//
//  Theme.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import Foundation
import SwiftUI

struct Theme { private init() {} }

extension Theme {
    struct Colors {
        // TODO: change to follow design system
        static let primary = Color.blue
    }
}

extension Theme {
    struct FontSize {
        // TODO: change to follow design system
        static let base = Font.system(size: 56)
    }
}

extension Theme {
    struct CornerRadius {
        // TODO: change to follow design system
        static let large: Double = 16
    }
}
