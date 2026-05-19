//
//  GoalsSummaryCard.swift
//  CentSage
//

import SwiftUI

struct GoalsSummaryCard: View {
  let summary: GoalOverviewSummary

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Goals")

        HStack(alignment: .firstTextBaseline) {
          VStack(alignment: .leading, spacing: CSSpacing.xxs) {
            Text("Total Saved")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            CSAmountText(amount: summary.totalSaved, size: .medium, color: CSColor.savings)
          }

          Spacer()

          VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
            Text("Active")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            Text("\(summary.activeGoalCount)")
              .font(CSFont.amountMedium)
              .foregroundStyle(CSColor.primaryText)
          }
        }

        Divider()
          .background(CSColor.divider)

        if let goal = summary.spotlightGoal {
          goalSpotlight(goal)
        } else {
          Text("No active goals need attention right now.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
        }
      }
    }
  }

  private func goalSpotlight(_ goal: GoalOverviewItem) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.sm) {
      HStack {
        Text(goal.title)
          .font(CSFont.headline)
          .foregroundStyle(CSColor.primaryText)

        Spacer()

        Text("\(Int((goal.progress * 100).rounded()))%")
          .font(CSFont.caption)
          .foregroundStyle(CSColor.savings)
      }

      CSProgressBar(progress: goal.progress, tint: CSColor.savings)

      if let weeklySavingsNeeded = goal.weeklySavingsNeeded {
        Text("Save \(weeklySavingsNeeded.currencyString)/week to stay on pace.")
          .font(CSFont.footnote)
          .foregroundStyle(CSColor.secondaryText)
      } else {
        Text("\(goal.remainingAmount.currencyString) left to reach the target.")
          .font(CSFont.footnote)
          .foregroundStyle(CSColor.secondaryText)
      }
    }
  }
}
