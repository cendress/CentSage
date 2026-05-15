//
//  CSSectionHeader.swift
//  CentSage
//

import SwiftUI

struct CSSectionHeader: View {
  let title: String
  var actionTitle: String? = nil
  var action: (() -> Void)? = nil
  
  var body: some View {
    HStack {
      Text(title)
        .font(CSFont.title3)
        .foregroundStyle(CSColor.primaryText)
      
      Spacer()
      
      if let actionTitle, let action {
        Button(actionTitle, action: action)
          .font(CSFont.callout)
          .foregroundStyle(CSColor.brandGreen)
      }
    }
  }
}
