//
//  Persistence.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  static var preview: PersistenceController = {
    let controller = PersistenceController(inMemory: true)
    return controller
  }()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "CentSage")
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }
}

extension PersistenceController {
  func createSampleBudget() -> Budget {
    let budget = Budget(context: container.viewContext)
    budget.category = "Groceries"
    budget.amount = 200.0
    budget.usedAmount = 150.0
    budget.startDate = Date()
    budget.endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
    budget.id = UUID()
    return budget
  }
}
