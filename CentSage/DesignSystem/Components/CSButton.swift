//
//  CSButton.swift
//  CentSage
//

import SwiftUI

struct CSButton: View {
  enum Variant {
    case primary
    case secondary
    case destructive
  }
  
  let title: String
  var systemImage: String? = nil
  var variant: Variant = .primary
  var isFullWidth: Bool = true
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: CSSpacing.xs) {
        if let systemImage {
          Image(systemName: systemImage)
        }
        
        Text(title)
          .font(CSFont.headline)
      }
      .frame(maxWidth: isFullWidth ? .infinity : nil)
      .padding(.horizontal, CSSpacing.md)
      .padding(.vertical, CSSpacing.sm)
      .foregroundStyle(foregroundColor)
      .background(backgroundShape)
    }
    .buttonStyle(.plain)
  }
  
  private var foregroundColor: Color {
    switch variant {
    case .primary:
      return .white
    case .secondary:
      return CSColor.primaryText
    case .destructive:
      return .white
    }
  }
  
  private var backgroundColor: Color {
    switch variant {
    case .primary:
      return CSColor.brandGreen
    case .secondary:
      return CSColor.secondaryBackground
    case .destructive:
      return CSColor.negative
    }
  }
  
  private var backgroundShape: some View {
    RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous)
      .fill(backgroundColor)
  }
}
