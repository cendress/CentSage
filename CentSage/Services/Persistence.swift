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
  func createSampleTransaction() -> Transaction {
    let transaction = Transaction(context: container.viewContext)
    transaction.name = "Sample Transaction"
    transaction.category = "Food"
    transaction.amount = 45.67
    transaction.date = Date()
    transaction.id = UUID()
    transaction.type = 0
    return transaction
  }
}
