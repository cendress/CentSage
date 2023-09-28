//
//  SavingsGoalForm.swift
//  CentSage
//
//  Created by Christopher Endress on 9/26/23.
//

import SwiftUI
import CoreData

struct SavingsGoalForm: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider
  
  @State private var goalName: String
  @State private var targetAmount: String
  
  @State private var currentAmount: String
  @State private var dueDate: Date
  
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the goal. Please try again."
  
  var goal: SavingsGoal?
  var isEditMode: Bool
  
  init(goal: SavingsGoal? = nil) {
    self.goal = goal
    self.isEditMode = goal != nil
    _goalName = State(initialValue: goal?.goalName ?? "")
    _targetAmount = State(initialValue: String(goal?.targetAmount ?? 0))
    _currentAmount = State(initialValue: String(goal?.currentAmount ?? 0))
    _dueDate = State(initialValue: goal?.dueDate ?? Date())
  }
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Goal Name", text: $goalName)
        
        HStack {
          Text("$")
          TextField("Target Amount", text: $targetAmount)
            .keyboardType(.decimalPad)
        }
        
        HStack {
          Text("$")
          TextField("Current Amount", text: $currentAmount)
            .keyboardType(.decimalPad)
        }
        
        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
          .accentColor(Color("CentSageGreen"))
      }
      .navigationTitle(isEditMode ? "Edit Goal" : "Add Savings Goal")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveGoal()
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
    .colorScheme(themeProvider.isDarkMode ? .dark : .light)
  }
  
  private func saveGoal() {
    guard let targetAmountDouble = Double(targetAmount),
          let currentAmountDouble = Double(currentAmount),
          !goalName.isEmpty else {
      self.errorMessage = "Please fill out all fields correctly."
      self.showErrorAlert = true
      return
    }
    
    let savingGoal = goal ?? SavingsGoal(context: viewContext)
    savingGoal.goalName = goalName
    savingGoal.targetAmount = targetAmountDouble
    savingGoal.currentAmount = currentAmountDouble
    savingGoal.dueDate = dueDate
    
    do {
      try viewContext.save()
      dismiss()
    } catch {
      let nsError = error as NSError
      print("Unresolved error \(nsError), \(nsError.userInfo)")
      self.errorMessage = "There was a problem saving the goal. Please try again."
      self.showErrorAlert = true
    }
  }
}

