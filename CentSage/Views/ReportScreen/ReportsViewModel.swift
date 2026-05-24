//
//  ReportsViewModel.swift
//  CentSage
//

import CoreData
import Foundation

final class ReportsViewModel: ObservableObject {
  @Published var selectedPeriod: ReportPeriod = .thisMonth
  @Published private(set) var transactions: [Transaction] = []

  private let context: NSManagedObjectContext
  private var contextObserver: NSObjectProtocol?

  init(context: NSManagedObjectContext) {
    self.context = context
    self.contextObserver = NotificationCenter.default.addObserver(
      forName: .NSManagedObjectContextObjectsDidChange,
      object: context,
      queue: .main
    ) { [weak self] _ in
      self?.refresh()
    }

    refresh()
  }

  deinit {
    if let contextObserver {
      NotificationCenter.default.removeObserver(contextObserver)
    }
  }

  var snapshot: ReportsSnapshot {
    ReportsCalculationService.snapshot(
      transactions: transactions,
      period: selectedPeriod
    )
  }

  func refresh() {
    transactions = fetchTransactions()
  }

  private func fetchTransactions() -> [Transaction] {
    let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]

    do {
      return try context.fetch(request)
    } catch {
      print("Failed to fetch report transactions: \(error)")
      return []
    }
  }
}
