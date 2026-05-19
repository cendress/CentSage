//
//  BudgetCalculationService.swift
//  CentSage
//

import CoreData
import Foundation

enum BudgetCalculationService {
  static func spentAmount(
    for budget: Budget,
    in context: NSManagedObjectContext,
    monthContaining date: Date = Date()
  ) -> Double {
    let transactionSpent = transactionSpentAmount(for: budget, in: context, monthContaining: date)

    // TODO: Once legacy Budget.usedAmount data is migrated into transactions, remove this fallback.
    return max(transactionSpent, budget.usedAmount)
  }

  static func remainingAmount(
    for budget: Budget,
    in context: NSManagedObjectContext,
    monthContaining date: Date = Date()
  ) -> Double {
    budget.amount - spentAmount(for: budget, in: context, monthContaining: date)
  }

  static func progress(
    for budget: Budget,
    in context: NSManagedObjectContext,
    monthContaining date: Date = Date()
  ) -> Double {
    guard budget.amount > 0 else { return 0 }
    return spentAmount(for: budget, in: context, monthContaining: date) / budget.amount
  }

  static func category(for budget: Budget) -> String {
    let storedCategory = budget.category?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !storedCategory.isEmpty {
      return storedCategory
    }

    let name = budget.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return name.isEmpty ? TransactionCreationService.uncategorizedCategory : name
  }

  private static func transactionSpentAmount(
    for budget: Budget,
    in context: NSManagedObjectContext,
    monthContaining date: Date
  ) -> Double {
    let category = category(for: budget)
    let calendar = Calendar.current

    guard
      let monthInterval = calendar.dateInterval(of: .month, for: date)
    else {
      return 0
    }

    let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    request.predicate = NSPredicate(
      format: "type == %d AND category == %@ AND date >= %@ AND date < %@",
      TransactionType.expense.rawValue,
      category,
      monthInterval.start as NSDate,
      monthInterval.end as NSDate
    )

    do {
      let transactions = try context.fetch(request)
      return transactions.reduce(0) { $0 + $1.amount }
    } catch {
      print("Failed to calculate budget spending: \(error)")
      return 0
    }
  }
}
