//
//  ReportsViewModel.swift
//  CentSage
//

import CoreData
import Foundation

final class ReportsViewModel: ObservableObject {
  @Published var selectedPeriod: ReportPeriod = .thisMonth
  @Published private(set) var transactions: [Transaction] = []
  @Published private(set) var goals: [SavingsGoal] = []

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
      goals: goals,
      period: selectedPeriod
    )
  }

  func refresh() {
    transactions = fetchTransactions()
    goals = fetchGoals()
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

  private func fetchGoals() -> [SavingsGoal] {
    let request: NSFetchRequest<SavingsGoal> = SavingsGoal.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \SavingsGoal.dueDate, ascending: true),
      NSSortDescriptor(keyPath: \SavingsGoal.goalName, ascending: true)
    ]

    do {
      return try context.fetch(request)
    } catch {
      print("Failed to fetch report goals: \(error)")
      return []
    }
  }
}
