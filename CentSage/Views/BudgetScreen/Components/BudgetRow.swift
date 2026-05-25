//
//  BudgetRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import CoreData
import SwiftUI

struct BudgetRow: View {
  @Environment(\.managedObjectContext) private var viewContext
  var budget: Budget

  @State private var showingInputSheet = false
  @State private var refreshToken = UUID()

  init(budget: Budget) {
    self.budget = budget
  }

  private var category: String {
    BudgetCalculationService.category(for: budget)
  }

  private var spentAmount: Double {
    _ = refreshToken
    return BudgetCalculationService.spentAmount(for: budget, in: viewContext)
  }

  private var remainingAmount: Double {
    budget.amount - spentAmount
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

            Text(category)
              .font(CSFont.subheadline)
              .foregroundStyle(CSColor.budget)
          }

          Spacer()

            dateRangeView
        }

        Divider()
          .background(CSColor.divider)

        BudgetProgressView(limit: budget.amount, spent: spentAmount, remaining: remainingAmount)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      showingInputSheet = true
    }
    .sheet(isPresented: $showingInputSheet) {
      QuickSpendingEntryView(budget: budget) {
        refreshToken = UUID()
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: viewContext)) { notification in
      guard Self.notificationContainsTransactionChange(notification) else { return }
      refreshToken = UUID()
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

  private static func notificationContainsTransactionChange(_ notification: Notification) -> Bool {
    let keys = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey]

    return keys.contains { key in
      guard let objects = notification.userInfo?[key] as? Set<NSManagedObject> else {
        return false
      }

      return objects.contains { $0 is Transaction }
    }
  }
}

#Preview {
  let sampleBudget = PersistenceController.shared.createSampleBudget()
  return BudgetRow(budget: sampleBudget)
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
