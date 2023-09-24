//
//  SavingsGoalsViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI
import CoreData

class SavingsGoalsViewModel: ObservableObject {
  
  var goals: [SavingsGoal] = [] {
    willSet {
      objectWillChange.send()
    }
  }
  
  private var viewContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    fetchGoals()
  }
  
  func fetchGoals() {
    let request: NSFetchRequest<SavingsGoal> = SavingsGoal.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \SavingsGoal.dueDate, ascending: true)]
    
    do {
      self.goals = try viewContext.fetch(request)
    } catch {
      print("Failed to fetch goals: \(error)")
    }
  }
}

