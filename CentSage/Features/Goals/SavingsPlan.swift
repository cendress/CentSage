//
//  SavingsPlan.swift
//  CentSage
//

import Foundation

struct SavingsPlan {
  let amountRemaining: Double
  let daysRemaining: Int?
  let weeksRemaining: Double?
  let weeklySavingsNeeded: Double?
  let isComplete: Bool
  let targetDatePassed: Bool
  let progress: Double
  let message: String
}
