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
  private var contextObserver: NSObjectProtocol?
  
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
    self.contextObserver = NotificationCenter.default.addObserver(
      forName: .NSManagedObjectContextObjectsDidChange,
      object: context,
      queue: .main
    ) { [weak self] notification in
      guard Self.notificationContainsTransactionChange(notification) else { return }
      self?.objectWillChange.send()
    }
    
    fetchBudgets()
  }

  deinit {
    if let contextObserver {
      NotificationCenter.default.removeObserver(contextObserver)
    }
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

  private static func notificationContainsTransactionChange(_ notification: Notification) -> Bool {
    let keys = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey]

    return keys.contains { key in
      guard let objects = notification.userInfo?[key] as? Set<NSManagedObject> else {
        return false
      }

      return objects.contains { $0 is Transaction }
    }
  }
}
