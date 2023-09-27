//
//  BudgetRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct BudgetRow: View {
  var budget: Budget
  
  @State private var showAlertIcon = false
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "dollarsign.circle.fill")
            .foregroundStyle(Color("CentSageGreen"))
          Text(budget.name ?? "Unknown name")
            .font(.headline)
            .fontWeight(.medium)
        }
        Text(String(format: "$%.2f / $%.2f", budget.usedAmount, budget.amount))
          .font(.subheadline)
        Text("From \(budget.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A") to \(budget.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
          .font(.footnote)
          .foregroundStyle(.gray)
      }
      Spacer()
      if budget.usedAmount > budget.amount {
        Image(systemName: "exclamationmark.triangle.fill")
          .foregroundColor(.red)
          .scaleEffect(showAlertIcon ? 1.5 : 1.0)
      }
    }
    .padding()
    .padding(.horizontal)
    .onAppear {
      withAnimation(.easeIn(duration: 0.5)) {
        showAlertIcon = budget.usedAmount > budget.amount
      }
    }
  }
}

#Preview {
  let sampleBudget = PersistenceController.shared.createSampleBudget()
  return BudgetRow(budget: sampleBudget)
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

