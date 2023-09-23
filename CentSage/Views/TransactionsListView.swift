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
  @FetchRequest(
    entity: Transaction.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
  ) private var transactions: FetchedResults<Transaction>
  
  @State private var isShowingNewTransactionView = false
  
  var body: some View {
    NavigationView {
      List(transactions, id: \.self) { transaction in
        TransactionRow(transaction: transaction)
      }
      .navigationTitle("Transactions")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            isShowingNewTransactionView = true
          }, label: {
            Image(systemName: "plus")
          })
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
  TransactionsListView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

