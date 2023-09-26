//
//  BudgetsViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI
import CoreData

class BudgetsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
  
  @Published var budgets: [Budget] = []
  
  private var viewContext: NSManagedObjectContext
  private var fetchedResultsController: NSFetchedResultsController<Budget>
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    
    let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Budget.startDate, ascending: false)]
    
    self.fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    
    super.init()
    
    self.fetchedResultsController.delegate = self
    
    fetchBudgets()
  }
  
  func fetchBudgets() {
    do {
      try fetchedResultsController.performFetch()
      budgets = fetchedResultsController.fetchedObjects ?? []
    } catch {
      print("Failed to fetch budgets: \(error)")
    }
  }
  
  func deleteBudgets(at offsets: IndexSet) {
    for index in offsets {
      let budget = budgets[index]
      viewContext.delete(budget)
    }
    
    do {
      try viewContext.save()
    } catch {
      print("Failed to save after deletion: \(error)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let updatedBudgets = controller.fetchedObjects as? [Budget] else { return }
    budgets = updatedBudgets
  }
}

