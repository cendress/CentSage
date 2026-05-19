//
//  BudgetSummaryCard.swift
//  CentSage
//

import SwiftUI

struct BudgetSummaryCard: View {
  let summary: BudgetOverviewSummary

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Budgets")

        HStack(alignment: .firstTextBaseline) {
          metric(title: "Limit", amount: summary.totalLimit, color: CSColor.primaryText)

          Spacer()

          metric(title: "Spent", amount: summary.totalSpent, color: CSColor.expense)
        }

        Text("\(summary.budgetCount) \(summary.budgetCount == 1 ? "budget" : "budgets") this month")
          .font(CSFont.footnote)
          .foregroundStyle(CSColor.tertiaryText)

        if !summary.attentionItems.isEmpty {
          Divider()
            .background(CSColor.divider)

          VStack(alignment: .leading, spacing: CSSpacing.sm) {
            ForEach(summary.attentionItems) { item in
              budgetStatusRow(item)
            }
          }
        } else if summary.budgetCount == 0 {
          Text("Add a budget to see category progress here.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
        } else {
          Text("No budgets are close to their limit.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
        }
      }
    }
  }

  private func metric(title: String, amount: Double, color: Color) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xxs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: color)
    }
  }

  private func budgetStatusRow(_ item: BudgetOverviewItem) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xs) {
      HStack {
        Text(item.category)
          .font(CSFont.subheadline)
          .foregroundStyle(CSColor.primaryText)

        Spacer()

        Text(item.isOverBudget ? "Over" : "\(Int((item.progress * 100).rounded()))%")
          .font(CSFont.caption)
          .foregroundStyle(item.isOverBudget ? CSColor.negative : CSColor.warning)
      }

      CSProgressBar(
        progress: item.progress,
        tint: item.isOverBudget ? CSColor.negative : CSColor.warning
      )

      Text(item.isOverBudget ? "\(item.remaining.absoluteCurrencyString) over" : "\(item.remaining.currencyString) left")
        .font(CSFont.footnote)
        .foregroundStyle(CSColor.secondaryText)
    }
  }
}
