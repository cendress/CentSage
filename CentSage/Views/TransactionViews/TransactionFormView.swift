//
//  TransactionFormView.swift
//  CentSage
//

import SwiftUI

struct TransactionFormView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider

  private let transaction: Transaction?
  private let onSave: () -> Void

  @State private var state: TransactionFormState
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the transaction. Please try again."

  init(transaction: Transaction? = nil, onSave: @escaping () -> Void = {}) {
    self.transaction = transaction
    self.onSave = onSave
    _state = State(initialValue: transaction.map(TransactionFormState.init(transaction:)) ?? TransactionFormState())
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          HStack {
            Text("$")
            TextField("Amount", text: $state.amount)
              .keyboardType(.decimalPad)
          }

          Picker("Type", selection: $state.type) {
            ForEach(TransactionType.allCases) { type in
              Text(type.title).tag(type)
            }
          }
          .pickerStyle(.segmented)
        }

        Section {
          Picker("Category", selection: $state.category) {
            Text("None").tag("")
            ForEach(CSCategoryPicker.transactionCategories, id: \.self) { category in
              Text(category).tag(category)
            }
            Text(TransactionCreationService.uncategorizedCategory)
              .tag(TransactionCreationService.uncategorizedCategory)
          }

          DatePicker("Date", selection: $state.date, displayedComponents: .date)

          TextField("Note (optional)", text: $state.note)
        }
      }
      .scrollContentBackground(.hidden)
      .background(CSColor.background)
      .navigationTitle(transaction == nil ? "Add Transaction" : "Edit Transaction")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Exit") {
            dismiss()
          }
          .foregroundStyle(CSColor.negative)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveTransaction()
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

  private func saveTransaction() {
    guard let amount = state.parsedAmount, amount > 0 else {
      errorMessage = "Please enter a valid positive amount."
      showErrorAlert = true
      return
    }

    do {
      if let transaction {
        try TransactionCreationService.update(
          transaction,
          amount: amount,
          type: state.type,
          category: state.category,
          date: state.date,
          note: state.note,
          source: inferredSource(for: transaction),
          in: viewContext
        )
      } else {
        try TransactionCreationService.createTransaction(
          amount: amount,
          type: state.type,
          category: state.category,
          date: state.date,
          note: state.note,
          source: .manualTransaction,
          in: viewContext
        )
      }

      onSave()
      dismiss()
    } catch {
      errorMessage = "There was a problem saving the transaction. Please try again."
      showErrorAlert = true
    }
  }

  private func inferredSource(for transaction: Transaction) -> EntrySource {
    let name = transaction.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    let category = TransactionCreationService.normalizedCategory(transaction.category)

    if name == "Quick entry" || name == "\(category) spending" {
      return .quickBudgetEntry
    }

    return .manualTransaction
  }
}
