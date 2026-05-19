//
//  SavingsProgressSection.swift
//  CentSage
//

import SwiftUI

struct SavingsProgressSection: View {
  let report: SavingsProgressReport

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Savings Progress")

        if !report.hasGoals {
          Text("Create a goal to track savings progress.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
        } else {
          HStack(alignment: .firstTextBaseline) {
            amountMetric(title: "Saved", amount: report.totalSaved, color: CSColor.savings)

            Spacer()

            amountMetric(title: "Target", amount: report.totalTarget, color: CSColor.primaryText)
          }

          CSProgressBar(progress: report.progress, tint: CSColor.savings)

          Text("\(report.activeGoalCount) active \(report.activeGoalCount == 1 ? "goal" : "goals")")
            .font(CSFont.footnote)
            .foregroundStyle(CSColor.secondaryText)
        }
      }
    }
  }

  private func amountMetric(title: String, amount: Double, color: Color) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xxs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: color)
    }
  }
}
