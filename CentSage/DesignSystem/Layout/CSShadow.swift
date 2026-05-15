//
//  CSShadow.swift
//  CentSage
//

import SwiftUI

struct CSShadowStyle {
  let color: Color
  let radius: CGFloat
  let x: CGFloat
  let y: CGFloat
}

enum CSShadow {
  static let card = CSShadowStyle(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
  static let subtle = CSShadowStyle(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
  static let none = CSShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
}
