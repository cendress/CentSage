//
//  AppDateFormatter.swift
//  CentSage
//

import Foundation

enum AppDateFormatter {
  static let shortDate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }()
  
  static let monthDay: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMM d")
    return formatter
  }()
}
