//
//  View+Modifiers.swift
//  CentSage
//

import SwiftUI

extension View {
  func csScreenBackground() -> some View {
    background(CSColor.background.ignoresSafeArea())
  }
  
  func csListRowStyle() -> some View {
    listRowSeparator(.hidden)
      .listRowBackground(CSColor.background)
  }
  
  func csCardShadow(_ style: CSShadowStyle = CSShadow.card) -> some View {
    modifier(CSCardShadowModifier(style: style))
  }
}

private struct CSCardShadowModifier: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  let style: CSShadowStyle
  
  func body(content: Content) -> some View {
    content.shadow(
      color: colorScheme == .dark ? .clear : style.color,
      radius: style.radius,
      x: style.x,
      y: style.y
    )
  }
}
