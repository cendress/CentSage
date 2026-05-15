//
//  CSCard.swift
//  CentSage
//

import SwiftUI

struct CSCard<Content: View>: View {
  private let padding: CGFloat
  private let content: Content
  
  init(padding: CGFloat = CSSpacing.md, @ViewBuilder content: () -> Content) {
    self.padding = padding
    self.content = content()
  }
  
  var body: some View {
    content
      .padding(padding)
      .background(CSColor.cardBackground)
      .clipShape(RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous)
          .stroke(CSColor.border, lineWidth: 1)
      }
      .csCardShadow()
  }
}
