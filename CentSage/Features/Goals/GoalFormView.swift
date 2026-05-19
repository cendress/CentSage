//
//  GoalFormView.swift
//  CentSage
//

import SwiftUI

struct GoalFormView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider

  private let goal: SavingsGoal?
  private let onSave: () -> Void

  @State private var state: GoalFormState
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the goal. Please try again."

  init(goal: SavingsGoal? = nil, onSave: @escaping () -> Void = {}) {
    self.goal = goal
    self.onSave = onSave
    _state = State(initialValue: goal.map(GoalFormState.init(goal:)) ?? GoalFormState())
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Goal Name", text: $state.name)

          HStack {
            Text("$")
            TextField("Target Amount", text: $state.targetAmount)
              .keyboardType(.decimalPad)
          }

          HStack {
            Text("$")
            TextField("Current Amount", text: $state.currentAmount)
              .keyboardType(.decimalPad)
          }
        } footer: {
          Text("Current amount can start at 0. A target date helps CentSage calculate a weekly plan.")
        }

        Section {
          Toggle("Set Target Date", isOn: $state.includeTargetDate)

          if state.includeTargetDate {
            DatePicker("Target Date", selection: $state.targetDate, displayedComponents: .date)
          }
        }
      }
      .scrollContentBackground(.hidden)
      .background(CSColor.background)
      .navigationTitle(goal == nil ? "Add Goal" : "Edit Goal")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Exit") {
            dismiss()
          }
          .foregroundStyle(CSColor.negative)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveGoal()
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

  private func saveGoal() {
    guard let targetAmount = state.parsedTargetAmount, targetAmount > 0 else {
      errorMessage = "Please enter a valid target amount."
      showErrorAlert = true
      return
    }

    let currentAmount = max(state.parsedCurrentAmount ?? 0, 0)
    let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
    let savedGoal = goal ?? SavingsGoal(context: viewContext)

    savedGoal.goalName = trimmedName.isEmpty ? "Savings Goal" : trimmedName
    savedGoal.targetAmount = targetAmount
    savedGoal.currentAmount = currentAmount
    savedGoal.dueDate = state.includeTargetDate ? state.targetDate : nil

    if savedGoal.id == nil {
      savedGoal.id = UUID()
    }

    do {
      try viewContext.save()
      onSave()
      dismiss()
    } catch {
      errorMessage = "There was a problem saving the goal. Please try again."
      showErrorAlert = true
    }
  }
}
