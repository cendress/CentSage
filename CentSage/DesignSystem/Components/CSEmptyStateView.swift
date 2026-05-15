//
//  CSEmptyStateView.swift
//  CentSage
//

import SwiftUI

struct CSEmptyStateView: View {
  let systemImage: String
  let title: String
  let message: String
  var buttonTitle: String? = nil
  var buttonSystemImage: String? = nil
  var action: (() -> Void)? = nil
  
  var body: some View {
    VStack(spacing: CSSpacing.md) {
      Image(systemName: systemImage)
        .font(.system(size: 52, weight: .semibold))
        .foregroundStyle(CSColor.brandGreen)
        .frame(width: 88, height: 88)
        .background(CSColor.brandGreenLight)
        .clipShape(Circle())
      
      VStack(spacing: CSSpacing.xs) {
        Text(title)
          .font(CSFont.title3)
          .foregroundStyle(CSColor.primaryText)
        
        Text(message)
          .font(CSFont.subheadline)
          .foregroundStyle(CSColor.secondaryText)
          .multilineTextAlignment(.center)
      }
      
      if let buttonTitle, let action {
        CSButton(
          title: buttonTitle,
          systemImage: buttonSystemImage,
          isFullWidth: false,
          action: action
        )
      }
    }
    .padding(CSSpacing.lg)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
