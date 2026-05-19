//
//  SavingsGoalPlanningService.swift
//  CentSage
//

import Foundation

enum SavingsGoalPlanningService {
  static func plan(for goal: SavingsGoal, today: Date = Date()) -> SavingsPlan {
    let targetAmount = max(goal.targetAmount, 0)
    let currentAmount = max(goal.currentAmount, 0)
    let amountRemaining = max(targetAmount - currentAmount, 0)
    let isComplete = targetAmount > 0 && amountRemaining == 0
    let progress = targetAmount > 0 ? min(max(currentAmount / targetAmount, 0), 1) : 0

    let datePlan = dueDatePlan(for: goal.dueDate, today: today)
    let targetDatePassed = datePlan.hasPassed && !isComplete
    let weeklySavingsNeeded = weeklySavingsNeeded(
      amountRemaining: amountRemaining,
      weeksRemaining: datePlan.weeksRemaining,
      isComplete: isComplete,
      targetDatePassed: targetDatePassed
    )

    return SavingsPlan(
      amountRemaining: amountRemaining,
      daysRemaining: datePlan.daysRemaining,
      weeksRemaining: datePlan.weeksRemaining,
      weeklySavingsNeeded: weeklySavingsNeeded,
      isComplete: isComplete,
      targetDatePassed: targetDatePassed,
      progress: progress,
      message: message(
        amountRemaining: amountRemaining,
        targetAmount: targetAmount,
        dueDate: goal.dueDate,
        weeklySavingsNeeded: weeklySavingsNeeded,
        isComplete: isComplete,
        targetDatePassed: targetDatePassed
      )
    )
  }

  private static func dueDatePlan(for dueDate: Date?, today: Date) -> (daysRemaining: Int?, weeksRemaining: Double?, hasPassed: Bool) {
    guard let dueDate else {
      return (nil, nil, false)
    }

    let calendar = Calendar.current
    let start = calendar.startOfDay(for: today)
    let end = calendar.startOfDay(for: dueDate)
    let rawDays = calendar.dateComponents([.day], from: start, to: end).day ?? 0

    if rawDays < 0 {
      return (0, 0, true)
    }

    return (rawDays, max(Double(rawDays) / 7, 1), false)
  }

  private static func weeklySavingsNeeded(
    amountRemaining: Double,
    weeksRemaining: Double?,
    isComplete: Bool,
    targetDatePassed: Bool
  ) -> Double? {
    guard !isComplete, !targetDatePassed, amountRemaining > 0, let weeksRemaining else {
      return nil
    }

    return amountRemaining / max(weeksRemaining, 1)
  }

  private static func message(
    amountRemaining: Double,
    targetAmount: Double,
    dueDate: Date?,
    weeklySavingsNeeded: Double?,
    isComplete: Bool,
    targetDatePassed: Bool
  ) -> String {
    if isComplete {
      return "Goal complete."
    }

    if targetDatePassed {
      return "Target date passed. Update your date to recalculate."
    }

    if targetAmount > 0 && amountRemaining <= targetAmount * 0.1 {
      return "You're almost there - \(amountRemaining.currencyString) left."
    }

    if let weeklySavingsNeeded, let dueDate {
      return "Save \(weeklySavingsNeeded.currencyString)/week to reach this by \(dueDate.csMonthDayFormatted)."
    }

    return "\(amountRemaining.currencyString) left. Add a target date for a weekly plan."
  }
}
