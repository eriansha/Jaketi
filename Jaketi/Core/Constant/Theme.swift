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
        static let primary = Color.blue // TODO: change to follow design system
    }
}

extension Theme {
    struct FontSize {
        static let large = Font.system(size: 56)
        static let xlarage = Font.system(size: 72)
        static let xxlarge = Font.system(size: 96)
    }
}

extension Theme {
    struct CornerRadius {
        static let large: Double = 16
    }
}
