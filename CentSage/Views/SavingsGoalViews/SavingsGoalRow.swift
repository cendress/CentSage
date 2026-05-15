//
//  SavingsGoalRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct SavingsGoalRow: View {
  @Binding var goal: SavingsGoal

  var progress: Double {
    guard goal.targetAmount > 0 else { return 0 }
    let rawProgress = goal.currentAmount / goal.targetAmount
    return max(0, min(rawProgress, 1))
  }

  var remainingAmount: Double {
    max(goal.targetAmount - goal.currentAmount, 0)
  }

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        HStack(alignment: .top, spacing: CSSpacing.sm) {
          Image(systemName: "star.fill")
            .font(.title3)
            .foregroundStyle(CSColor.savings)
            .frame(width: 42, height: 42)
            .background(CSColor.savings.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

          VStack(alignment: .leading, spacing: CSSpacing.xxs) {
            Text(goal.goalName ?? "Unknown goal name")
              .font(CSFont.headline)
              .foregroundStyle(CSColor.primaryText)

            if let dueDate = goal.dueDate {
              Text("Due: \(dueDate.csShortFormatted)")
                .font(CSFont.footnote)
                .foregroundStyle(CSColor.secondaryText)
            }
          }

          Spacer()
        }

        CSProgressBar(progress: progress, tint: CSColor.savings)

        HStack(alignment: .firstTextBaseline) {
          VStack(alignment: .leading, spacing: CSSpacing.xxs) {
            Text("Target")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            CSAmountText(amount: goal.targetAmount, size: .small)
          }

          Spacer()

          VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
            Text("Current")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            CSAmountText(amount: goal.currentAmount, size: .small, color: CSColor.savings)
          }
        }

        if remainingAmount > 0 {
          Text("\(remainingAmount.currencyString) to go")
            .font(CSFont.footnote)
            .foregroundStyle(CSColor.tertiaryText)
        }
      }
    }
  }
}

//#Preview {
//  SavingsGoalRow(goal: PersistenceController.preview.createSampleSavingsGoal())
//    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
