//
//  MonthOverMonthSection.swift
//  CentSage
//

import SwiftUI

struct MonthOverMonthSection: View {
  let report: MonthOverMonthReport

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Month over Month")

        HStack(alignment: .firstTextBaseline) {
          monthMetric(title: report.currentMonthTitle, amount: report.currentExpenses)

          Spacer()

          monthMetric(title: report.previousMonthTitle, amount: report.previousExpenses)
        }

        Divider()
          .background(CSColor.divider)

        HStack(spacing: CSSpacing.sm) {
          Image(systemName: report.isHigher ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
            .font(.title3)
            .foregroundStyle(report.isHigher ? CSColor.negative : CSColor.positive)

          Text(report.message)
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
  }

  private func monthMetric(title: String, amount: Double) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xxs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: CSColor.expense)
    }
  }
}
