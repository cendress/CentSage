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
  
  func csCardShadow() -> some View {
    modifier(CSCardShadowModifier())
  }
}

private struct CSCardShadowModifier: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  
  func body(content: Content) -> some View {
    content.shadow(
      color: colorScheme == .dark ? .clear : .black.opacity(0.06),
      radius: CSShadow.card.radius,
      x: CSShadow.card.x,
      y: CSShadow.card.y
    )
  }
}
