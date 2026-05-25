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
}
