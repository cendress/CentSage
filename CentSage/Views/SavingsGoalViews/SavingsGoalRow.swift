//
//  SavingsGoalRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct SavingsGoalRow: View {
  @Binding var goal: SavingsGoal
  
  var progress: Double {
    let rawProgress = goal.currentAmount / goal.targetAmount
    return max(0, min(rawProgress, 1))
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text(goal.goalName ?? "Unknown goal name")
          .font(.headline)
        Spacer()
        if let dueDate = goal.dueDate {
          Text("Due: \(DateFormatter.shortDate.string(from: dueDate))")
            .font(.subheadline)
            .foregroundColor(.gray)
        }
      }
      
      ProgressView(value: progress)
        .progressViewStyle(CustomProgressView())
        .frame(height: 20)
        .padding(.vertical, 8)
      
      HStack {
        Text(String(format: "Target: $%.2f", goal.targetAmount))
        Spacer()
        Text(String(format: "Current: $%.2f", goal.currentAmount))
          .fontWeight(.bold)
      }
      .font(.subheadline)
      
    }
    .padding(15)
    .background(Color(UIColor.systemBackground))
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
  }
}

//#Preview {
//  SavingsGoalRow(goal: PersistenceController.preview.createSampleSavingsGoal())
//    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

