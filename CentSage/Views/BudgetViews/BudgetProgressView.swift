//
//  BudgetProgressView.swift
//  CentSage
//

import SwiftUI

struct BudgetProgressView: View {
  let limit: Double
  let spent: Double
  let remaining: Double

  private var isOverBudget: Bool {
    remaining < 0
  }

  private var progress: Double {
    guard limit > 0 else { return 0 }
    return spent / limit
  }

  var body: some View {
    VStack(alignment: .leading, spacing: CSSpacing.sm) {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: CSSpacing.xxs) {
          Text("Monthly Limit")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.secondaryText)

          CSAmountText(amount: limit, size: .small)
        }

        Spacer()

        VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
          Text("Spent")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.secondaryText)

          CSAmountText(amount: spent, size: .small, color: isOverBudget ? CSColor.negative : CSColor.primaryText)
        }
      }

      CSProgressBar(progress: progress, tint: isOverBudget ? CSColor.negative : CSColor.brandGreen)

      Text("Remaining: \(remaining.currencyString)")
        .font(CSFont.subheadline)
        .foregroundStyle(isOverBudget ? CSColor.negative : CSColor.secondaryText)
    }
  }
}
