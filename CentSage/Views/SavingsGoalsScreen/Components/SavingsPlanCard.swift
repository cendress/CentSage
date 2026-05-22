//
//  SavingsPlanCard.swift
//  CentSage
//

import SwiftUI

struct SavingsPlanCard: View {
  let goal: SavingsGoal
  let plan: SavingsPlan

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Savings Plan")

        Text(plan.message)
          .font(CSFont.headline)
          .foregroundStyle(messageColor)
          .fixedSize(horizontal: false, vertical: true)

        CSProgressBar(progress: plan.progress, tint: CSColor.savings)

        HStack(alignment: .firstTextBaseline) {
          planMetric(title: "Saved", amount: goal.currentAmount, color: CSColor.savings)

          Spacer()

          planMetric(title: "Target", amount: goal.targetAmount, color: CSColor.primaryText)
        }

        if let daysRemaining = plan.daysRemaining, !plan.isComplete {
          Text("\(daysRemaining) \(daysRemaining == 1 ? "day" : "days") remaining")
            .font(CSFont.footnote)
            .foregroundStyle(CSColor.secondaryText)
        }
      }
    }
  }

  private var messageColor: Color {
    if plan.targetDatePassed {
      return CSColor.warning
    }

    if plan.isComplete {
      return CSColor.positive
    }

    return CSColor.primaryText
  }

  private func planMetric(title: String, amount: Double, color: Color) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xxs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: color)
    }
  }
}
