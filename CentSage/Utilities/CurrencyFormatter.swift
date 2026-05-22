//
//  CurrencyFormatter.swift
//  CentSage
//

import Foundation

enum CurrencyFormatter {
  static let shared: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter
  }()
  
  static func string(from amount: Double) -> String {
    shared.string(from: NSNumber(value: amount)) ?? "$0.00"
  }
}
