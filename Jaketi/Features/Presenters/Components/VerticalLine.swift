//
//  VerticalLine.swift
//  Jaketi
//
//  Created by Hilmy Noerfatih on 20/07/23.
//

import SwiftUI

struct VerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}
