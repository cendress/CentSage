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
  
  @State private var selectedCategory = "All"
  @State private var isShowingNewTransactionView = false
  
  var fetchRequest: FetchRequest<Transaction> {
    FetchRequest(
      entity: Transaction.entity(),
      sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
      predicate: selectedCategory == "All" ? nil : NSPredicate(format: "category == %@", selectedCategory)
    )
  }
  
  var transactions: FetchedResults<Transaction> { fetchRequest.wrappedValue }
  
  var body: some View {
    NavigationView {
      VStack {
        Picker("Category", selection: $selectedCategory) {
          Text("All").tag("All")
          Text("Food").tag("Food")
          Text("Home").tag("Home")
          Text("Transport").tag("Transport")
          Text("Entertainment").tag("Entertainment")
          Text("Health").tag("Health")
          Text("Shopping").tag("Shopping")
        }
        .pickerStyle(MenuPickerStyle())
        
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
}

#Preview {
  TransactionsListView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


