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
}
