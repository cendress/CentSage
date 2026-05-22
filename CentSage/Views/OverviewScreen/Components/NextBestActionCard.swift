//
//  NextBestActionCard.swift
//  CentSage
//

import SwiftUI

struct NextBestActionCard: View {
  let action: NextBestAction

  var body: some View {
    CSCard {
      HStack(alignment: .top, spacing: CSSpacing.md) {
        Image(systemName: action.systemImage)
          .font(.title3)
          .foregroundStyle(tintColor)
          .frame(width: 42, height: 42)
          .background(tintColor.opacity(0.14))
          .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

        VStack(alignment: .leading, spacing: CSSpacing.xs) {
          Text("Next Best Action")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.secondaryText)

          Text(action.title)
            .font(CSFont.headline)
            .foregroundStyle(CSColor.primaryText)

          Text(action.message)
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
  }

  private var tintColor: Color {
    switch action.priority {
    case .warning:
      return CSColor.negative
    case .budget:
      return CSColor.warning
    case .savings:
      return CSColor.savings
    case .empty:
      return CSColor.info
    case .positive:
      return CSColor.positive
    }
  }
}
