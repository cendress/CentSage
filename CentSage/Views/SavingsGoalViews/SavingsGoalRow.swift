//
//  SavingsGoalRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct SavingsGoalRow: View {
  @Binding var goal: SavingsGoal

  private var plan: SavingsPlan {
    SavingsGoalPlanningService.plan(for: goal)
  }

  private var progressPercent: Int {
    Int((plan.progress * 100).rounded())
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
              Text("Target: \(dueDate.csShortFormatted)")
                .font(CSFont.footnote)
                .foregroundStyle(CSColor.secondaryText)
            }
          }

          Spacer()

          Text("\(progressPercent)%")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.savings)
        }

        CSProgressBar(progress: plan.progress, tint: plan.targetDatePassed ? CSColor.warning : CSColor.savings)

        HStack(alignment: .firstTextBaseline) {
          VStack(alignment: .leading, spacing: CSSpacing.xxs) {
            Text("Current")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            CSAmountText(amount: goal.currentAmount, size: .small, color: CSColor.savings)
          }

          Spacer()

          VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
            Text("Target")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            CSAmountText(amount: goal.targetAmount, size: .small)
          }
        }

        Text(rowMessage)
          .font(CSFont.footnote)
          .foregroundStyle(plan.targetDatePassed ? CSColor.warning : CSColor.tertiaryText)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }

  private var rowMessage: String {
    if let weeklySavingsNeeded = plan.weeklySavingsNeeded {
      return "\(weeklySavingsNeeded.currencyString)/week needed"
    }

    return plan.message
  }
}

//#Preview {
//  SavingsGoalRow(goal: PersistenceController.preview.createSampleSavingsGoal())
//    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
