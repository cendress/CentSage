//
//  GoalFormState.swift
//  CentSage
//

import Foundation

struct GoalFormState {
  var name: String = ""
  var targetAmount: String = ""
  var currentAmount: String = "0"
  var includeTargetDate = false
  var targetDate = Date()

  init() {}

  init(goal: SavingsGoal) {
    name = goal.goalName ?? ""
    targetAmount = goal.targetAmount == 0 ? "" : String(format: "%.2f", goal.targetAmount)
    currentAmount = String(format: "%.2f", goal.currentAmount)
    includeTargetDate = goal.dueDate != nil
    targetDate = goal.dueDate ?? Date()
  }

  var parsedTargetAmount: Double? {
    Double(targetAmount)
  }

  var parsedCurrentAmount: Double? {
    Double(currentAmount)
  }
}
