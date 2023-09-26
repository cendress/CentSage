//
//  SavingsGoalsViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI
import CoreData

class SavingsGoalsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
  
  @Published var goals: [SavingsGoal] = []
  
  private var viewContext: NSManagedObjectContext
  private var fetchedResultsController: NSFetchedResultsController<SavingsGoal>
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    
    let request: NSFetchRequest<SavingsGoal> = SavingsGoal.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \SavingsGoal.dueDate, ascending: true)]
    
    self.fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    
    super.init()
    
    self.fetchedResultsController.delegate = self
    
    fetchGoals()
  }
  
  func fetchGoals() {
    do {
      try fetchedResultsController.performFetch()
      goals = fetchedResultsController.fetchedObjects ?? []
    } catch {
      print("Failed to fetch goals: \(error)")
    }
  }
  
  func deleteGoals(at offsets: IndexSet) {
    for index in offsets {
      let goal = goals[index]
      viewContext.delete(goal)
    }
    
    do {
      try viewContext.save()
    } catch {
      print("Failed to save context after deletion: \(error)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let updatedGoals = controller.fetchedObjects as? [SavingsGoal] else { return }
    goals = updatedGoals
  }
}


