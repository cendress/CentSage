//
//  NewSavingsGoal.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI
import CoreData

struct NewSavingsGoal: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider
  
  @State private var goalName = ""
  @State private var targetAmount = ""
  @State private var currentAmount = ""
  @State private var dueDate: Date? = nil
  @State private var includeDueDate = false
  
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the goal. Please try again."
  
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
        
        Toggle(isOn: $includeDueDate) {
          Text("Include Due Date")
        }
        
        if includeDueDate {
          DatePicker("Due Date", selection: Binding($dueDate, replacingWith: Date()), displayedComponents: .date)
            .accentColor(Color("CentSageGreen"))
        }
      }
      .navigationTitle("Add Savings Goal")
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
    
    let newGoal = SavingsGoal(context: viewContext)
    newGoal.goalName = goalName
    newGoal.targetAmount = targetAmountDouble
    newGoal.currentAmount = currentAmountDouble
    newGoal.dueDate = includeDueDate ? dueDate : nil
    newGoal.id = UUID()
    
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

#Preview {
  NewSavingsGoal().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

extension Binding {
  init(_ source: Binding<Value?>, replacingWith defaultValue: Value) {
    self.init(
      get: { source.wrappedValue ?? defaultValue },
      set: { newValue in
        source.wrappedValue = newValue
      }
    )
  }
}
