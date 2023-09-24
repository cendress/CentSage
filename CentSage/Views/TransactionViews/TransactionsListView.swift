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
          Text("Transport").tag("Transport")
          Text("Entertainment").tag("Entertainment")
          Text("Health").tag("Health")
          Text("Shopping").tag("Shopping")
        }
        .pickerStyle(MenuPickerStyle())
        
        List(viewModel.transactions, id: \.self) { transaction in
          TransactionRow(transaction: transaction)
        }
        .navigationTitle("Transactions")
        .navigationBarItems(trailing: Button(action: {
          isShowingNewTransactionView = true
        }) {
          Image(systemName: "plus")
        })
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


