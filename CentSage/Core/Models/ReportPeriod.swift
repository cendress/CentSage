//
//  ReportPeriod.swift
//  CentSage
//

import Foundation

enum ReportPeriod: String, CaseIterable, Identifiable {
  case thisMonth
  case lastMonth
  case lastThreeMonths

  var id: String { rawValue }

  var title: String {
    switch self {
    case .thisMonth:
      return "This Month"
    case .lastMonth:
      return "Last Month"
    case .lastThreeMonths:
      return "Last 3 Months"
    }
  }

  func interval(referenceDate: Date = Date(), calendar: Calendar = .current) -> DateInterval {
    switch self {
    case .thisMonth:
      return calendar.dateInterval(of: .month, for: referenceDate) ?? DateInterval(start: referenceDate, duration: 0)
    case .lastMonth:
      let date = calendar.date(byAdding: .month, value: -1, to: referenceDate) ?? referenceDate
      return calendar.dateInterval(of: .month, for: date) ?? DateInterval(start: date, duration: 0)
    case .lastThreeMonths:
      guard
        let currentMonth = calendar.dateInterval(of: .month, for: referenceDate),
        let start = calendar.date(byAdding: .month, value: -2, to: currentMonth.start)
      else {
        return DateInterval(start: referenceDate, duration: 0)
      }

      return DateInterval(start: start, end: currentMonth.end)
    }
  }

  func comparisonMonthDate(referenceDate: Date = Date(), calendar: Calendar = .current) -> Date {
    switch self {
    case .lastMonth:
      return calendar.date(byAdding: .month, value: -1, to: referenceDate) ?? referenceDate
    case .thisMonth, .lastThreeMonths:
      return referenceDate
    }
  }
}
