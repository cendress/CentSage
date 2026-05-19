//
//  SpendingByCategorySection.swift
//  CentSage
//

import SwiftUI

struct SpendingByCategorySection: View {
  let categories: [CategorySpendingReport]

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Spending by Category")

        if categories.isEmpty {
          Text("Add transactions to see your spending patterns.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
        } else {
          VStack(alignment: .leading, spacing: CSSpacing.md) {
            ForEach(categories.prefix(6)) { item in
              categoryRow(item)
            }
          }
        }
      }
    }
  }

  private func categoryRow(_ item: CategorySpendingReport) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xs) {
      HStack {
        Text(item.category)
          .font(CSFont.subheadline)
          .foregroundStyle(CSColor.primaryText)

        Spacer()

        CSAmountText(amount: item.total, size: .small, color: CSColor.expense)
      }

      CSProgressBar(progress: item.share, tint: CSColor.expense)
    }
  }
}
