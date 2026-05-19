//
//  BudgetFormView.swift
//  CentSage
//

import SwiftUI

struct BudgetFormView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider

  private let budget: Budget?
  private let onSave: () -> Void

  @State private var state: BudgetFormState
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the budget. Please try again."

  init(budget: Budget? = nil, onSave: @escaping () -> Void = {}) {
    self.budget = budget
    self.onSave = onSave
    _state = State(initialValue: budget.map(BudgetFormState.init(budget:)) ?? BudgetFormState())
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Name", text: $state.name)

          Picker("Category", selection: $state.category) {
            Text("Same as name").tag("")
            ForEach(CSCategoryPicker.transactionCategories, id: \.self) { category in
              Text(category).tag(category)
            }
          }

          HStack {
            Text("$")
            TextField("Monthly Limit", text: $state.amount)
              .keyboardType(.decimalPad)
          }
        }

        Section {
          Toggle("Include Dates", isOn: $state.includeDates)

          if state.includeDates {
            DatePicker("Start Date", selection: $state.startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $state.endDate, displayedComponents: .date)
          }
        }
      }
      .scrollContentBackground(.hidden)
      .background(CSColor.background)
      .navigationTitle(budget == nil ? "Add Budget" : "Edit Budget")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Exit") {
            dismiss()
          }
          .foregroundStyle(CSColor.negative)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveBudget()
          }
          .foregroundStyle(CSColor.brandGreen)
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

  private func saveBudget() {
    guard let amount = state.parsedAmount, amount > 0 else {
      errorMessage = "Please enter a valid positive monthly limit."
      showErrorAlert = true
      return
    }

    let savedBudget = budget ?? Budget(context: viewContext)
    let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedCategory = state.category.trimmingCharacters(in: .whitespacesAndNewlines)

    savedBudget.name = trimmedName.isEmpty ? (trimmedCategory.isEmpty ? "Budget" : trimmedCategory) : trimmedName
    savedBudget.category = trimmedCategory.isEmpty ? nil : trimmedCategory
    savedBudget.amount = amount

    if state.includeDates {
      savedBudget.startDate = state.startDate
      savedBudget.endDate = state.endDate
    } else {
      savedBudget.startDate = nil
      savedBudget.endDate = nil
    }

    if savedBudget.id == nil {
      savedBudget.id = UUID()
    }

    do {
      try viewContext.save()
      onSave()
      dismiss()
    } catch {
      errorMessage = "There was a problem saving the budget. Please try again."
      showErrorAlert = true
    }
  }
}
