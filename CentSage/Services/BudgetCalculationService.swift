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

    return budget.usedAmount + transactionSpent
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
      let dateInterval = transactionDateInterval(for: budget, monthContaining: date, calendar: calendar)
    else {
      return 0
    }

    let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    request.predicate = NSPredicate(
      format: "type == %d AND category == %@ AND date >= %@ AND date < %@",
      TransactionType.expense.rawValue,
      category,
      dateInterval.start as NSDate,
      dateInterval.end as NSDate
    )

    do {
      let transactions = try context.fetch(request)
      return transactions.reduce(0) { $0 + $1.amount }
    } catch {
      print("Failed to calculate budget spending: \(error)")
      return 0
    }
  }

  private static func transactionDateInterval(
    for budget: Budget,
    monthContaining date: Date,
    calendar: Calendar
  ) -> DateInterval? {
    guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
      return nil
    }

    let startBoundary = transactionStartBoundary(for: budget, calendar: calendar)
    let start = max(monthInterval.start, startBoundary ?? monthInterval.start)
    let end = min(monthInterval.end, inclusiveEndBoundary(for: budget, calendar: calendar) ?? monthInterval.end)

    guard start < end else { return nil }
    return DateInterval(start: start, end: end)
  }

  private static func transactionStartBoundary(for budget: Budget, calendar: Calendar) -> Date? {
    guard let startDate = budget.startDate else {
      return budget.createdAt
    }

    let selectedDayStart = calendar.startOfDay(for: startDate)

    guard
      let createdAt = budget.createdAt,
      calendar.isDate(startDate, inSameDayAs: createdAt)
    else {
      return selectedDayStart
    }

    return max(selectedDayStart, createdAt)
  }

  private static func inclusiveEndBoundary(for budget: Budget, calendar: Calendar) -> Date? {
    guard let endDate = budget.endDate else { return nil }
    return calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate))
  }
}
