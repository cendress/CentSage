//
//  BudgetRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct BudgetRow: View {
  @Environment(\.managedObjectContext) private var viewContext
  var budget: Budget

  @State private var usedAmount: Double
  @State private var showingInputSheet = false

  init(budget: Budget) {
    self.budget = budget
    self._usedAmount = State(initialValue: budget.usedAmount)
  }

  var remainingAmount: Double {
    budget.amount - usedAmount
  }

  var isOverBudget: Bool {
    remainingAmount < 0
  }

  var progress: Double {
    guard budget.amount > 0 else { return 0 }
    return usedAmount / budget.amount
  }

  var remainingAmountString: String {
    "Remaining: \(remainingAmount.currencyString)"
  }

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        HStack(alignment: .top, spacing: CSSpacing.sm) {
          Image(systemName: "dollarsign.circle.fill")
            .font(.title2)
            .foregroundStyle(CSColor.budget)
            .frame(width: 44, height: 44)
            .background(CSColor.budget.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

          VStack(alignment: .leading, spacing: CSSpacing.xxs) {
            Text(budget.name ?? "Unknown name")
              .font(CSFont.headline)
              .foregroundStyle(CSColor.primaryText)

            dateRangeView
          }

          Spacer()

          Image(systemName: "plus.circle.fill")
            .font(.title3)
            .foregroundStyle(CSColor.brandGreen)
        }

        Divider()
          .background(CSColor.divider)

        VStack(alignment: .leading, spacing: CSSpacing.sm) {
          HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: CSSpacing.xxs) {
              Text("Total Budget")
                .font(CSFont.caption)
                .foregroundStyle(CSColor.secondaryText)

              CSAmountText(amount: budget.amount, size: .small)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
              Text("Spent")
                .font(CSFont.caption)
                .foregroundStyle(CSColor.secondaryText)

              CSAmountText(amount: usedAmount, size: .small, color: isOverBudget ? CSColor.negative : CSColor.primaryText)
            }
          }

          CSProgressBar(progress: progress, tint: isOverBudget ? CSColor.negative : CSColor.brandGreen)

          Text(remainingAmountString)
            .font(CSFont.subheadline)
            .foregroundStyle(isOverBudget ? CSColor.negative : CSColor.secondaryText)
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      showingInputSheet = true
    }
    .sheet(isPresented: $showingInputSheet) {
      InputSpendingView(usedAmount: $usedAmount, onSave: saveChanges)
    }
    .padding(.horizontal)
    .padding(.vertical, CSSpacing.xs)
  }

  @ViewBuilder
  private var dateRangeView: some View {
    if budget.startDate != nil || budget.endDate != nil {
      VStack(alignment: .leading, spacing: 2) {
        if let startDate = budget.startDate {
          Text("From: \(startDate.formatted(date: .abbreviated, time: .omitted))")
        }

        if let endDate = budget.endDate {
          Text("To: \(endDate.formatted(date: .abbreviated, time: .omitted))")
        }
      }
      .font(CSFont.footnote)
      .foregroundStyle(CSColor.secondaryText)
    }
  }

  func saveChanges() {
    budget.usedAmount = usedAmount
    do {
      try viewContext.save()
    } catch {
      print("Failed to save updated used amount: \(error)")
    }
  }
}

#Preview {
  let sampleBudget = PersistenceController.shared.createSampleBudget()
  return BudgetRow(budget: sampleBudget)
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
