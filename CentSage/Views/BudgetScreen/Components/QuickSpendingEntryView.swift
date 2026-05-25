//
//  QuickSpendingEntryView.swift
//  CentSage
//

import SwiftUI

struct QuickSpendingEntryView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider

  let budget: Budget
  var onSave: () -> Void

  @State private var amount = ""
  @State private var note = ""
  @State private var showingAlert = false
  @State private var alertMessage = ""

  private var category: String {
    BudgetCalculationService.category(for: budget)
  }

  private var spentAmount: Double {
    BudgetCalculationService.spentAmount(for: budget, in: viewContext)
  }

  private var remainingAmount: Double {
    budget.amount - spentAmount
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
          ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: CSSpacing.lg) {
            CSCard {
              VStack(alignment: .leading, spacing: CSSpacing.sm) {
                Text(category)
                  .font(CSFont.title2)
                  .foregroundStyle(CSColor.primaryText)

                Text(budget.name ?? "Budget")
                  .font(CSFont.subheadline)
                  .foregroundStyle(CSColor.secondaryText)

                HStack {
                  VStack(alignment: .leading, spacing: CSSpacing.xxs) {
                    Text("Remaining")
                      .font(CSFont.caption)
                      .foregroundStyle(CSColor.secondaryText)

                    CSAmountText(
                      amount: remainingAmount,
                      size: .medium,
                      color: remainingAmount < 0 ? CSColor.negative : CSColor.primaryText
                    )
                  }

                  Spacer()

                  VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
                    Text("Spent")
                      .font(CSFont.caption)
                      .foregroundStyle(CSColor.secondaryText)

                    CSAmountText(amount: spentAmount, size: .small)
                  }
                }
              }
            }

            VStack(alignment: .leading, spacing: CSSpacing.sm) {
              Text("Amount")
                .font(CSFont.caption)
                .foregroundStyle(CSColor.secondaryText)

              HStack {
                Text("$")
                  .font(CSFont.amountMedium)
                  .foregroundStyle(CSColor.secondaryText)

                TextField("0.00", text: $amount)
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

              TextField("Note (optional)", text: $note)
                .font(CSFont.body)
                .padding(CSSpacing.md)
                .background(CSColor.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous))
                .overlay {
                  RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous)
                    .stroke(CSColor.border, lineWidth: 1)
                }
            }
          }
          .padding(CSSpacing.md)
        }

        CSButton(title: "Save Spending", systemImage: "checkmark", action: saveSpending)
          .padding(.horizontal, CSSpacing.md)
          .padding(.top, CSSpacing.sm)
          .padding(.bottom, CSSpacing.lg)
          .background(CSColor.background)
      }
      .csScreenBackground()
      .navigationTitle("Quick Spending")
      .navigationBarTitleDisplayMode(.inline)
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
    }
    .colorScheme(themeProvider.isDarkMode ? .dark : .light)
  }

  private func saveSpending() {
    guard let amountDouble = Double(amount), amountDouble > 0 else {
      alertMessage = "Please enter a valid positive amount."
      showingAlert = true
      return
    }

    do {
      try TransactionCreationService.createTransaction(
        amount: amountDouble,
        type: .expense,
        category: category,
        date: Date(),
        note: note,
        source: .quickBudgetEntry,
        in: viewContext
      )
      onSave()
      dismiss()
    } catch {
      alertMessage = "There was a problem saving this spending entry."
      showingAlert = true
    }
  }
}
