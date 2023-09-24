//
//  BudgetsViewModel.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI
import CoreData

class BudgetsViewModel: ObservableObject {
  @Published var budgets: [Budget] = []
  
  private var viewContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    fetchBudgets()
  }
  
  func fetchBudgets() {
    let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Budget.startDate, ascending: false)]
    
    do {
      self.budgets = try viewContext.fetch(fetchRequest)
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
}
