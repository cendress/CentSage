//
//  BudgetRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct BudgetRow: View {
  var budget: Budget
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(budget.category ?? "Unknown category")
      Text(String(format: "$%.2f / $%.2f", budget.usedAmount, budget.amount))
        .font(.headline)
      Text("From \(budget.startDate ?? Date()) to \(budget.endDate ?? Date())")
    }
  }
}

#Preview {
  let sampleBudget = PersistenceController.shared.createSampleBudget()
  return BudgetRow(budget: sampleBudget)
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
