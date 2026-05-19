//
//  MonthlySummaryCard.swift
//  CentSage
//

import SwiftUI

struct MonthlySummaryCard: View {
  let summary: MonthlySummary

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Monthly Summary")

        HStack(alignment: .top, spacing: CSSpacing.md) {
          summaryMetric(
            title: "Income",
            amount: summary.income,
            color: CSColor.income
          )

          Divider()
            .background(CSColor.divider)

          summaryMetric(
            title: "Expenses",
            amount: summary.expenses,
            color: CSColor.expense
          )
        }

        Divider()
          .background(CSColor.divider)

        HStack(alignment: .firstTextBaseline) {
          VStack(alignment: .leading, spacing: CSSpacing.xxs) {
            Text("Leftover")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            Text(summary.net >= 0 ? "Available after spending" : "Spending is ahead of income")
              .font(CSFont.footnote)
              .foregroundStyle(CSColor.tertiaryText)
          }

          Spacer()

          CSAmountText(
            amount: summary.net,
            size: .medium,
            color: summary.net >= 0 ? CSColor.income : CSColor.expense
          )
        }
      }
    }
  }

  private func summaryMetric(title: String, amount: Double, color: Color) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: color)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
