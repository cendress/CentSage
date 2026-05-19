//
//  BudgetFormState.swift
//  CentSage
//

import Foundation

struct BudgetFormState {
  var name = ""
  var category = ""
  var amount = ""
  var startDate = Date()
  var endDate = Date()
  var includeDates = false

  init() {}

  init(budget: Budget) {
    name = budget.name ?? ""
    category = budget.category ?? ""
    amount = budget.amount == 0 ? "" : String(format: "%.2f", budget.amount)
    startDate = budget.startDate ?? Date()
    endDate = budget.endDate ?? Date()
    includeDates = budget.startDate != nil || budget.endDate != nil
  }

  var parsedAmount: Double? {
    Double(amount)
  }
}
