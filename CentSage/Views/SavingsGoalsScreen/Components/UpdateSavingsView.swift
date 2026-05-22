//
//  UpdateSavingsView.swift
//  CentSage
//

import SwiftUI

struct UpdateSavingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider

  @ObservedObject var viewModel: SavingsGoalsViewModel
  @Binding var refreshTrigger: Bool

  let goal: SavingsGoal

  @State private var amountToAdd = ""
  @State private var showingAlert = false
  @State private var alertMessage = ""

  private var plan: SavingsPlan {
    SavingsGoalPlanningService.plan(for: goal)
  }

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: CSSpacing.lg) {
          CSCard {
            VStack(alignment: .leading, spacing: CSSpacing.md) {
              Text(goal.goalName ?? "Savings Goal")
                .font(CSFont.title2)
                .foregroundStyle(CSColor.primaryText)

              HStack(alignment: .firstTextBaseline) {
                amountMetric(title: "Saved", amount: goal.currentAmount, color: CSColor.savings)

                Spacer()

                amountMetric(title: "Target", amount: goal.targetAmount, color: CSColor.primaryText)
              }

              CSProgressBar(progress: plan.progress, tint: CSColor.savings)
            }
          }

          SavingsPlanCard(goal: goal, plan: plan)

          VStack(alignment: .leading, spacing: CSSpacing.sm) {
            Text("Amount to Add")
              .font(CSFont.caption)
              .foregroundStyle(CSColor.secondaryText)

            HStack {
              Text("$")
                .font(CSFont.amountMedium)
                .foregroundStyle(CSColor.secondaryText)

              TextField("0.00", text: $amountToAdd)
                .font(CSFont.amountMedium)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
            }
            .padding(CSSpacing.md)
            .background(CSColor.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous))
            .overlay {
              RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous)
                .stroke(CSColor.border, lineWidth: 1)
            }
          }

          CSButton(title: "Save Progress", systemImage: "checkmark", action: updateSavings)
        }
        .padding(CSSpacing.md)
      }
      .csScreenBackground()
      .navigationTitle("Update Savings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Exit") {
            dismiss()
          }
          .foregroundStyle(CSColor.negative)
        }
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
    }
    .colorScheme(themeProvider.isDarkMode ? .dark : .light)
  }

  private func amountMetric(title: String, amount: Double, color: Color) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xxs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: color)
    }
  }

  private func updateSavings() {
    guard let addedAmount = Double(amountToAdd), addedAmount > 0 else {
      alertMessage = "Please enter a valid positive amount."
      showingAlert = true
      return
    }

    goal.currentAmount += addedAmount

    do {
      try viewContext.save()
      viewModel.fetchGoals()
      refreshTrigger.toggle()
      dismiss()
    } catch {
      alertMessage = "Failed to save changes: \(error.localizedDescription)"
      showingAlert = true
    }
  }
}
