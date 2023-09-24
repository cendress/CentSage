//
//  TransactionsViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import CoreData
import SwiftUI

class TransactionsViewModel: ObservableObject {
  @Published var transactions: [Transaction] = []
  
  var selectedCategory = "All" {
    didSet { fetchTransactions() }
  }
  
  private var viewContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    fetchTransactions()
  }
  
  private func fetchTransactions() {
    let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
    if selectedCategory != "All" {
      fetchRequest.predicate = NSPredicate(format: "category == %@", selectedCategory)
    }
    
    do {
      self.transactions = try viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to fetch transactions: \(error)")
    }
  }
  
  func deleteTransactions(at offsets: IndexSet) {
    for index in offsets {
      let transaction = transactions[index]
      viewContext.delete(transaction)
    }
    
    do {
      try viewContext.save()
      fetchTransactions()
    } catch {
      print("Failed to save context after deletion: \(error)")
    }
  }
}
