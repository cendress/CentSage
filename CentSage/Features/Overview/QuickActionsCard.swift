//
//  QuickActionsCard.swift
//  CentSage
//

import SwiftUI

struct QuickActionsCard: View {
  let addSpending: () -> Void
  let addTransaction: () -> Void
  let addBudget: () -> Void
  let addGoal: () -> Void

  private let columns = [
    GridItem(.flexible(), spacing: CSSpacing.sm),
    GridItem(.flexible(), spacing: CSSpacing.sm)
  ]

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Quick Actions")

        LazyVGrid(columns: columns, spacing: CSSpacing.sm) {
          CSButton(
            title: "Add Spending",
            systemImage: "bolt.fill",
            isFullWidth: true,
            action: addSpending
          )

          CSButton(
            title: "Add Transaction",
            systemImage: "plus.circle.fill",
            variant: .secondary,
            isFullWidth: true,
            action: addTransaction
          )

          CSButton(
            title: "Add Budget",
            systemImage: "dollarsign.circle.fill",
            variant: .secondary,
            isFullWidth: true,
            action: addBudget
          )

          CSButton(
            title: "Add Goal",
            systemImage: "star.fill",
            variant: .secondary,
            isFullWidth: true,
            action: addGoal
          )
        }
      }
    }
  }
}
