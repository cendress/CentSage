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
  @ObservedObject var viewModel: TransactionsListViewModel
  
  @State private var isShowingNewTransactionView = false
  
  var body: some View {
    NavigationView {
      List(viewModel.transactions, id: \.self) { transaction in
        TransactionRow(transaction: transaction)
      }
      .navigationTitle("Transactions")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            isShowingNewTransactionView = true
          }) {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(isPresented: $isShowingNewTransactionView) {
        NewTransactionView()
          .environment(\.managedObjectContext, self.viewContext)
      }
    }
  }
}

#Preview {
  TransactionsListView(viewModel: TransactionsListViewModel(context: PersistenceController.preview.container.viewContext))
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
