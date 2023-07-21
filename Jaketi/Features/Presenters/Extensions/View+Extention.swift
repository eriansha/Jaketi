//
//  View+Extention.swift
//  Jaketi
//
//  Created by Hilmy Noerfatih on 21/07/23.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
