//
//  TransactionsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI
import CoreData

struct TransactionsListView: View {
  @StateObject private var viewModel: TransactionsViewModel

  @State private var isShowingNewTransactionView = false
  @State private var selectedTransaction: Transaction?

  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: TransactionsViewModel(context: context))
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        CSCategoryPicker(
          title: "Category",
          categories: CSCategoryPicker.transactionCategories,
          selection: $viewModel.selectedCategory,
          includesAllOption: true
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, CSSpacing.md)
        .padding(.top, CSSpacing.sm)

        if viewModel.transactions.isEmpty {
          emptyTransactionsView
        } else {
          transactionListView
        }
      }
      .csScreenBackground()
      .navigationViewStyle(StackNavigationViewStyle())
      .navigationTitle("Transactions")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          isShowingNewTransactionView = true
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
        }
      )
      .sheet(isPresented: $isShowingNewTransactionView) {
        TransactionFormView {
          viewModel.refreshTransactions()
        }
      }
      .sheet(item: $selectedTransaction, onDismiss: {
        viewModel.refreshTransactions()
      }) { transaction in
        TransactionFormView(transaction: transaction) {
          viewModel.refreshTransactions()
        }
      }
    }
    .tint(CSColor.brandGreen)
  }

  var emptyTransactionsView: some View {
    CSEmptyStateView(
      systemImage: "list.bullet.rectangle",
      title: "No transactions yet!",
      message: "Tap the button to add income or expenses as they happen.",
      buttonTitle: "Add Transaction",
      buttonSystemImage: "plus",
      action: {
        isShowingNewTransactionView = true
      }
    )
  }

  var transactionListView: some View {
    List {
      if !viewModel.transactions.isEmpty {
        CSCard {
          HStack {
            Text("Total")
              .font(CSFont.headline)
              .foregroundStyle(CSColor.primaryText)

            Spacer()

            CSAmountText(
              amount: viewModel.totalAmount,
              size: .medium,
              color: viewModel.totalAmount < 0 ? CSColor.expense : CSColor.income
            )
          }
        }
        .listRowInsets(EdgeInsets(top: CSSpacing.sm, leading: CSSpacing.md, bottom: CSSpacing.sm, trailing: CSSpacing.md))
        .csListRowStyle()
      }

      ForEach(viewModel.transactions, id: \.self) { transaction in
        Button {
          selectedTransaction = transaction
        } label: {
          TransactionRow(transaction: transaction)
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets(top: CSSpacing.xs, leading: CSSpacing.md, bottom: CSSpacing.xs, trailing: CSSpacing.md))
        .csListRowStyle()
      }
      .onDelete(perform: viewModel.deleteTransactions)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(CSColor.background)
  }
}

#Preview {
  TransactionsListView(context: PersistenceController.preview.container.viewContext)
}
