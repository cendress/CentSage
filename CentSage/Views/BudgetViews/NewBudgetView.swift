//
//  NewBudgetView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI
import CoreData

struct NewBudgetView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var name = ""
  @State private var amount = ""
  @State private var startDate = Date()
  @State private var endDate = Date()
  
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the budget. Please try again."
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Name", text: $name)
        HStack {
          Text("$")
          TextField("Budget Amount", text: $amount)
            .keyboardType(.decimalPad)
        }
        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
      }
      .navigationTitle("Add Budget")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveBudget()
          }
          .accentColor(Color("CentSageGreen"))
        }
      }
      .alert(isPresented: $showErrorAlert) {
        Alert(
          title: Text("Saving Error"),
          message: Text(errorMessage),
          dismissButton: .default(Text("OK"))
        )
      }
    }
  }
  
  private func saveBudget() {
    guard let amountDouble = Double(self.amount), amountDouble > 0 else {
      self.errorMessage = "Invalid amount. Please enter a positive numeric value."
      self.showErrorAlert = true
      return
    }
    
    let newBudget = Budget(context: viewContext)
    newBudget.name = self.name
    newBudget.amount = amountDouble
    newBudget.startDate = self.startDate
    newBudget.endDate = self.endDate
    newBudget.id = UUID()
    newBudget.usedAmount = 0
    
    do {
      try viewContext.save()
      dismiss()
    } catch {
      let nsError = error as NSError
      print("Unresolved error \(nsError), \(nsError.userInfo)")
      self.errorMessage = "There was a problem saving the budget. Please try again."
      self.showErrorAlert = true
    }
  }
}

#Preview {
  NewBudgetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

