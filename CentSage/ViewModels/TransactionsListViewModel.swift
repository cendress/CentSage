//
//  TransactionsListViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import Foundation
import SwiftUI
import CoreData

class TransactionsListViewModel: ObservableObject {
  @Published var transactions: [Transaction] = []
  private var viewContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    fetchTransactions()
  }
  
  func fetchTransactions() {
    let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    do {
      self.transactions = try viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to fetch transactions: \(error)")
    }
  }
}
