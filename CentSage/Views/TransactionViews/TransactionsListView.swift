//
//  TransactionsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI
import CoreData

struct TransactionsListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @StateObject private var viewModel: TransactionsViewModel
  
  @State private var isShowingNewTransactionView = false
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: TransactionsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Picker("Category", selection: $viewModel.selectedCategory) {
          Text("All").tag("All")
          Text("Food").tag("Food")
          Text("Home").tag("Home")
          Text("Work").tag("Work")
          Text("Transportation").tag("Transportation")
          Text("Entertainment").tag("Entertainment")
          Text("Leisure").tag("Leisure")
          Text("Health").tag("Health")
          Text("Gift").tag("Gift")
          Text("Shopping").tag("Shopping")
          Text("Investment").tag("Investment")
          Text("Other").tag("Other")
        }
        .pickerStyle(MenuPickerStyle())
        
        List {
          ForEach(viewModel.transactions, id: \.self) { transaction in
            TransactionRow(transaction: transaction)
          }
          .onDelete(perform: viewModel.deleteTransactions)
          
          if !viewModel.transactions.isEmpty {
            Text("Total: \(viewModel.totalAmount < 0 ? "-" : "")$\((abs(viewModel.totalAmount)), specifier: "%.2f")")
              .font(.headline)
              .padding(.top, 10)
          }
        }
        .navigationTitle("Transactions")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              isShowingNewTransactionView = true
            }, label: {
              Image(systemName: "plus")
            })
          }
          ToolbarItem(placement: .topBarLeading) {
            EditButton()
          }
        }
        .sheet(isPresented: $isShowingNewTransactionView) {
          NewTransactionView()
            .environment(\.managedObjectContext, viewContext)
        }
      }
    }
  }
}

#Preview {
  TransactionsListView(context: PersistenceController.preview.container.viewContext)
}


