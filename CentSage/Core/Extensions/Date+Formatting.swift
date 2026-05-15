//
//  Date+Formatting.swift
//  CentSage
//

import Foundation

extension Date {
  var csShortFormatted: String {
    AppDateFormatter.shortDate.string(from: self)
  }
  
  var csMonthDayFormatted: String {
    AppDateFormatter.monthDay.string(from: self)
  }
}
