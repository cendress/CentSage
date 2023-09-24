//
//  SavingsGoalRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct SavingsGoalRow: View {
  var goal: SavingsGoal
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(goal.goalName ?? "Unknown goal name")
      Text(String(format: "Target: $%.2f", goal.targetAmount))
        .font(.subheadline)
      Text(String(format: "Current: $%.2f", goal.currentAmount))
        .font(.subheadline)
      Text(goal.dueDate != nil ? "\(goal.dueDate!)" : "Unknown due date")
    }
  }
}

#Preview {
  SavingsGoalRow(goal: PersistenceController.preview.createSampleSavingsGoal())
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

