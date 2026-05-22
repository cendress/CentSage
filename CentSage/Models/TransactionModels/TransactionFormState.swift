//
//  TransactionFormState.swift
//  CentSage
//

import Foundation

struct TransactionFormState {
  var amount: String = ""
  var type: TransactionType = .expense
  var category: String = ""
  var date: Date = Date()
  var note: String = ""

  init() {}

  init(transaction: Transaction) {
    amount = transaction.amount == 0 ? "" : String(format: "%.2f", transaction.amount)
    type = TransactionType(coreDataValue: transaction.type)
    date = transaction.date ?? Date()
    note = transaction.note ?? ""

    if transaction.category == TransactionCreationService.uncategorizedCategory {
      category = ""
    } else {
      category = transaction.category ?? ""
    }
  }

  var parsedAmount: Double? {
    Double(amount)
  }
}
