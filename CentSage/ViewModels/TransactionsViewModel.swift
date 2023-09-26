//
//  TransactionsViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import CoreData
import SwiftUI

class TransactionsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
  @Published var transactions: [Transaction] = []
  
  var selectedCategory = "All" {
    didSet { fetchTransactions() }
  }
  
  private var viewContext: NSManagedObjectContext
  private var fetchedResultsController: NSFetchedResultsController<Transaction>
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    
    let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
    
    self.fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    
    super.init()
    
    self.fetchedResultsController.delegate = self
    
    fetchTransactions()
  }
  
  private func fetchTransactions() {
    if selectedCategory != "All" {
      fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "category == %@", selectedCategory)
    } else {
      fetchedResultsController.fetchRequest.predicate = nil
    }
    
    do {
      try fetchedResultsController.performFetch()
      transactions = fetchedResultsController.fetchedObjects ?? []
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
    } catch {
      print("Failed to save context after deletion: \(error)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let updatedTransactions = controller.fetchedObjects as? [Transaction] else { return }
    transactions = updatedTransactions
  }
}

