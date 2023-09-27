//
//  BudgetRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI

struct BudgetRow: View {
  @Environment(\.managedObjectContext) private var viewContext
  var budget: Budget
  
  @State private var showAlertIcon = false
  @State private var usedAmount: Double
  @State private var showingInputSheet = false
  
  init(budget: Budget) {
    self.budget = budget
    self._usedAmount = State(initialValue: budget.usedAmount)
  }
  
  var remainingAmount: Double {
    budget.amount - usedAmount
  }
  
  var remainingAmountString: String {
    if remainingAmount < 0 {
      let absAmount = abs(remainingAmount)
      return String(format: "Remaining: -$%.2f", absAmount)
    } else {
      return String(format: "Remaining: $%.2f", remainingAmount)
    }
  }
  
  var body: some View {
    VStack(spacing: 10) {
      HStack {
        Image(systemName: "dollarsign.circle.fill")
          .foregroundStyle(Color("CentSageGreen"))
          .font(.largeTitle)
        VStack(alignment: .leading) {
          Text(budget.name ?? "Unknown name")
            .font(.headline)
            .fontWeight(.medium)
          VStack(alignment: .leading) {
            Text("From: \(budget.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
            Text("To: \(budget.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
          }
          .font(.subheadline)
          .foregroundColor(.gray)
        }
        Spacer()
      }
      .padding(.horizontal)
      
      Divider().padding(.horizontal)
      
      VStack {
        Text(String(format: "Total Budget: $%.2f", budget.amount))
          .font(.subheadline)
        
        ProgressView(value: min(usedAmount, budget.amount), total: budget.amount)
          .progressViewStyle(CustomProgressView())
        
        Text(remainingAmountString)
          .font(.subheadline)
          .foregroundColor(remainingAmount < 0 ? .red : .primary)
      }
      .padding(.horizontal)
    }
    .padding()
    .onAppear {
      withAnimation(.easeIn(duration: 0.5)) {
        showAlertIcon = budget.usedAmount > budget.amount
      }
    }
    .onTapGesture {
      showingInputSheet = true
    }
    .sheet(isPresented: $showingInputSheet) {
      InputSpendingView(usedAmount: $usedAmount, onSave: saveChanges)
    }
  }
  
  func saveChanges() {
    budget.usedAmount = usedAmount
    do {
      try viewContext.save()
    } catch {
      print("Failed to save updated used amount: \(error)")
    }
  }
}

#Preview {
  let sampleBudget = PersistenceController.shared.createSampleBudget()
  return BudgetRow(budget: sampleBudget)
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

