//
//  TransactionCreationService.swift
//  CentSage
//

import CoreData
import Foundation

enum TransactionCreationService {
  static let uncategorizedCategory = "Uncategorized"

  @discardableResult
  static func createTransaction(
    amount: Double,
    type: TransactionType = .expense,
    category: String?,
    date: Date = Date(),
    note: String? = nil,
    source: EntrySource = .manualTransaction,
    in context: NSManagedObjectContext
  ) throws -> Transaction {
    let transaction = Transaction(context: context)
    apply(
      amount: amount,
      type: type,
      category: category,
      date: date,
      note: note,
      source: source,
      to: transaction
    )
    transaction.id = UUID()

    try context.save()
    return transaction
  }

  static func update(
    _ transaction: Transaction,
    amount: Double,
    type: TransactionType,
    category: String?,
    date: Date,
    note: String?,
    source: EntrySource = .manualTransaction,
    in context: NSManagedObjectContext
  ) throws {
    apply(
      amount: amount,
      type: type,
      category: category,
      date: date,
      note: note,
      source: source,
      to: transaction
    )

    if transaction.id == nil {
      transaction.id = UUID()
    }

    try context.save()
  }

  static func normalizedCategory(_ category: String?) -> String {
    let trimmed = category?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return trimmed.isEmpty ? uncategorizedCategory : trimmed
  }

  private static func apply(
    amount: Double,
    type: TransactionType,
    category: String?,
    date: Date,
    note: String?,
    source: EntrySource,
    to transaction: Transaction
  ) {
    let category = normalizedCategory(category)
    let trimmedNote = note?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

    transaction.amount = amount
    transaction.type = type.rawValue
    transaction.category = category
    transaction.date = date
    transaction.note = trimmedNote
    transaction.name = defaultName(for: type, category: category, source: source)

    // TODO: Persist EntrySource in Core Data during a future lightweight migration.
  }

  private static func defaultName(
    for type: TransactionType,
    category: String,
    source: EntrySource
  ) -> String {
    switch source {
    case .quickBudgetEntry:
      return category == uncategorizedCategory ? "Quick entry" : "\(category) spending"
    case .manualTransaction:
      return category == uncategorizedCategory ? type.title : "\(category) \(type.title.lowercased())"
    }
  }
}
