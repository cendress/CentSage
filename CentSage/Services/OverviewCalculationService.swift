//
//  OverviewCalculationService.swift
//  CentSage
//

import CoreData
import Foundation

struct MonthlySummary {
  let income: Double
  let expenses: Double
  let net: Double
}

struct BudgetOverviewItem: Identifiable {
  let id: NSManagedObjectID
  let title: String
  let category: String
  let limit: Double
  let spent: Double
  let remaining: Double
  let progress: Double

  var isOverBudget: Bool {
    remaining < 0
  }

  var isCloseToLimit: Bool {
    progress >= 0.75
  }
}

struct BudgetOverviewSummary {
  let budgetCount: Int
  let totalLimit: Double
  let totalSpent: Double
  let attentionItems: [BudgetOverviewItem]
}

struct GoalOverviewItem: Identifiable {
  let id: NSManagedObjectID
  let title: String
  let currentAmount: Double
  let targetAmount: Double
  let remainingAmount: Double
  let dueDate: Date?
  let progress: Double
  let weeklySavingsNeeded: Double?
}

struct GoalOverviewSummary {
  let totalSaved: Double
  let activeGoalCount: Int
  let spotlightGoal: GoalOverviewItem?
}

enum OverviewCalculationService {
  private static let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
    return formatter
  }()

  static func monthTitle(for date: Date = Date()) -> String {
    monthFormatter.string(from: date)
  }

  static func monthlySummary(
    from transactions: [Transaction],
    monthContaining date: Date = Date()
  ) -> MonthlySummary {
    let monthlyTransactions = transactions.filter { transaction in
      guard let transactionDate = transaction.date else { return false }
      return Calendar.current.isDate(transactionDate, equalTo: date, toGranularity: .month)
    }

    let income = monthlyTransactions
      .filter { TransactionType(coreDataValue: $0.type) == .income }
      .reduce(0) { $0 + $1.amount }

    let expenses = monthlyTransactions
      .filter { TransactionType(coreDataValue: $0.type) == .expense }
      .reduce(0) { $0 + $1.amount }

    return MonthlySummary(income: income, expenses: expenses, net: income - expenses)
  }

  static func budgetSummary(
    from budgets: [Budget],
    context: NSManagedObjectContext,
    monthContaining date: Date = Date()
  ) -> BudgetOverviewSummary {
    let items = budgets.map { budget in
      let spent = BudgetCalculationService.spentAmount(for: budget, in: context, monthContaining: date)
      let remaining = budget.amount - spent
      let progress = budget.amount > 0 ? spent / budget.amount : 0

      return BudgetOverviewItem(
        id: budget.objectID,
        title: budget.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? budget.name ?? "Budget" : "Budget",
        category: BudgetCalculationService.category(for: budget),
        limit: budget.amount,
        spent: spent,
        remaining: remaining,
        progress: progress
      )
    }

    let attentionItems = items
      .filter { $0.isOverBudget || $0.isCloseToLimit }
      .sorted {
        if $0.isOverBudget != $1.isOverBudget {
          return $0.isOverBudget
        }

        return $0.progress > $1.progress
      }

    return BudgetOverviewSummary(
      budgetCount: budgets.count,
      totalLimit: items.reduce(0) { $0 + $1.limit },
      totalSpent: items.reduce(0) { $0 + $1.spent },
      attentionItems: Array(attentionItems.prefix(3))
    )
  }

  static func goalsSummary(
    from goals: [SavingsGoal],
    today: Date = Date()
  ) -> GoalOverviewSummary {
    let items = goals.map { goal in
      let target = goal.targetAmount
      let current = goal.currentAmount
      let remaining = max(target - current, 0)
      let progress = target > 0 ? min(max(current / target, 0), 1) : 0
      let weeklySavings = weeklySavingsNeeded(toSave: remaining, by: goal.dueDate, today: today)

      return GoalOverviewItem(
        id: goal.objectID,
        title: goal.goalName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? goal.goalName ?? "Savings goal" : "Savings goal",
        currentAmount: current,
        targetAmount: target,
        remainingAmount: remaining,
        dueDate: goal.dueDate,
        progress: progress,
        weeklySavingsNeeded: weeklySavings
      )
    }

    let activeItems = items.filter { $0.remainingAmount > 0 }
    let spotlight = activeItems.sorted {
      switch ($0.weeklySavingsNeeded, $1.weeklySavingsNeeded) {
      case let (left?, right?):
        return left > right
      case (.some, .none):
        return true
      case (.none, .some):
        return false
      case (.none, .none):
        return $0.progress > $1.progress
      }
    }.first

    return GoalOverviewSummary(
      totalSaved: goals.reduce(0) { $0 + $1.currentAmount },
      activeGoalCount: activeItems.count,
      spotlightGoal: spotlight
    )
  }

  static func recentTransactions(
    from transactions: [Transaction],
    limit: Int = 5
  ) -> [Transaction] {
    Array(transactions.sorted {
      ($0.date ?? .distantPast) > ($1.date ?? .distantPast)
    }.prefix(limit))
  }

  static func nextBestAction(
    transactions: [Transaction],
    budgets: [Budget],
    goals: [SavingsGoal],
    context: NSManagedObjectContext,
    today: Date = Date()
  ) -> NextBestAction {
    let budgetSummary = budgetSummary(from: budgets, context: context, monthContaining: today)
    let goalsSummary = goalsSummary(from: goals, today: today)

    if let overBudget = budgetSummary.attentionItems.first(where: { $0.isOverBudget }) {
      return NextBestAction(
        title: "Check \(overBudget.category)",
        message: "You're over by \(overBudget.remaining.absoluteCurrencyString) this month.",
        systemImage: "exclamationmark.triangle.fill",
        priority: .warning
      )
    }

    if let closeBudget = budgetSummary.attentionItems.first(where: { !$0.isOverBudget }) {
      let percent = Int((closeBudget.progress * 100).rounded())
      return NextBestAction(
        title: "\(closeBudget.category) is \(percent)% used",
        message: "You have \(closeBudget.remaining.currencyString) left for the month.",
        systemImage: "chart.pie.fill",
        priority: .budget
      )
    }

    if let goal = goalsSummary.spotlightGoal, let weeklySavings = goal.weeklySavingsNeeded {
      let dueText = goal.dueDate.map { " by \($0.csMonthDayFormatted)" } ?? ""
      return NextBestAction(
        title: "Keep \(goal.title) moving",
        message: "Save \(weeklySavings.currencyString)/week\(dueText).",
        systemImage: "star.fill",
        priority: .savings
      )
    }

    if transactions.isEmpty {
      return NextBestAction(
        title: "Add your first transaction",
        message: "Once you add income or spending, your monthly summary will come alive.",
        systemImage: "plus.circle.fill",
        priority: .empty
      )
    }

    if budgets.isEmpty {
      return NextBestAction(
        title: "Add your first budget",
        message: "Budgets help CentSage show what is left for the month.",
        systemImage: "dollarsign.circle.fill",
        priority: .empty
      )
    }

    if goals.isEmpty {
      return NextBestAction(
        title: "Add a savings goal",
        message: "A simple goal gives your leftover money a job.",
        systemImage: "star.fill",
        priority: .empty
      )
    }

    return NextBestAction(
      title: "You're on track",
      message: "Your month looks steady. Keep logging the small stuff.",
      systemImage: "checkmark.circle.fill",
      priority: .positive
    )
  }

  private static func weeklySavingsNeeded(
    toSave remainingAmount: Double,
    by dueDate: Date?,
    today: Date
  ) -> Double? {
    guard remainingAmount > 0, let dueDate else { return nil }

    let calendar = Calendar.current
    let start = calendar.startOfDay(for: today)
    let end = calendar.startOfDay(for: dueDate)
    let days = max(calendar.dateComponents([.day], from: start, to: end).day ?? 0, 0)
    let weeks = max(Double(days) / 7, 1)

    return remainingAmount / weeks
  }
}
