//
//  TransactionType.swift
//  CentSage
//

import Foundation

enum TransactionType: Int16, CaseIterable, Identifiable {
  case expense = 0
  case income = 1

  var id: Int16 { rawValue }

  var title: String {
    switch self {
    case .expense:
      return "Expense"
    case .income:
      return "Income"
    }
  }

  init(coreDataValue: Int16) {
    self = TransactionType(rawValue: coreDataValue) ?? .expense
  }
}
