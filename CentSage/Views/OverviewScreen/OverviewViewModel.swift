//
//  OverviewViewModel.swift
//  CentSage
//

import CoreData
import Foundation

final class OverviewViewModel: ObservableObject {
  @Published private(set) var transactions: [Transaction] = []
  @Published private(set) var budgets: [Budget] = []

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

  var monthTitle: String {
    OverviewCalculationService.monthTitle()
  }

  var monthlySummary: MonthlySummary {
    OverviewCalculationService.monthlySummary(from: transactions)
  }

  var budgetSummary: BudgetOverviewSummary {
    OverviewCalculationService.budgetSummary(from: budgets, context: context)
  }

  var recentTransactions: [Transaction] {
    OverviewCalculationService.recentTransactions(from: transactions)
  }

  var nextBestAction: NextBestAction {
    OverviewCalculationService.nextBestAction(
      transactions: transactions,
      budgets: budgets,
      context: context
    )
  }

  func refresh() {
    transactions = fetchTransactions()
    budgets = fetchBudgets()
  }

  private func fetchTransactions() -> [Transaction] {
    let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]

    do {
      return try context.fetch(request)
    } catch {
      print("Failed to fetch overview transactions: \(error)")
      return []
    }
  }

  private func fetchBudgets() -> [Budget] {
    let request: NSFetchRequest<Budget> = Budget.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \Budget.name, ascending: true),
      NSSortDescriptor(keyPath: \Budget.startDate, ascending: false)
    ]

    do {
      return try context.fetch(request)
    } catch {
      print("Failed to fetch overview budgets: \(error)")
      return []
    }
  }

}
