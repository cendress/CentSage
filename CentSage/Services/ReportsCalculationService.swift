//
//  ReportsCalculationService.swift
//  CentSage
//

import Foundation

struct CategorySpendingReport: Identifiable {
  let category: String
  let total: Double
  let share: Double

  var id: String { category }
}

struct IncomeExpenseReport {
  let income: Double
  let expenses: Double
  let net: Double

  var hasTransactions: Bool {
    income > 0 || expenses > 0
  }
}

struct MonthOverMonthReport {
  let currentMonthTitle: String
  let previousMonthTitle: String
  let currentExpenses: Double
  let previousExpenses: Double
  let difference: Double

  var isHigher: Bool {
    difference > 0
  }

  var message: String {
    if currentExpenses == 0 && previousExpenses == 0 {
      return "Add transactions to compare monthly spending."
    }

    if difference == 0 {
      return "Spending is unchanged from last month."
    }

    let direction = isHigher ? "up" : "down"
    return "Spending is \(direction) \(abs(difference).currencyString) from last month."
  }
}

struct SavingsProgressReport {
  let totalSaved: Double
  let totalTarget: Double
  let activeGoalCount: Int

  var progress: Double {
    guard totalTarget > 0 else { return 0 }
    return min(max(totalSaved / totalTarget, 0), 1)
  }

  var hasGoals: Bool {
    totalTarget > 0
  }
}

struct ReportsSnapshot {
  let period: ReportPeriod
  let categories: [CategorySpendingReport]
  let incomeExpense: IncomeExpenseReport
  let monthOverMonth: MonthOverMonthReport
  let savingsProgress: SavingsProgressReport
}

enum ReportsCalculationService {
  private static let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMM yyyy")
    return formatter
  }()

  static func snapshot(
    transactions: [Transaction],
    goals: [SavingsGoal],
    period: ReportPeriod,
    referenceDate: Date = Date()
  ) -> ReportsSnapshot {
    let periodTransactions = transactions.filter {
      guard let date = $0.date else { return false }
      return period.interval(referenceDate: referenceDate).contains(date)
    }

    let incomeExpense = incomeExpenseReport(from: periodTransactions)
    let categories = categorySpending(from: periodTransactions)
    let comparison = monthOverMonthReport(
      from: transactions,
      period: period,
      referenceDate: referenceDate
    )
    let savings = savingsProgress(from: goals)

    return ReportsSnapshot(
      period: period,
      categories: categories,
      incomeExpense: incomeExpense,
      monthOverMonth: comparison,
      savingsProgress: savings
    )
  }

  private static func categorySpending(from transactions: [Transaction]) -> [CategorySpendingReport] {
    let expenseTransactions = transactions.filter {
      TransactionType(coreDataValue: $0.type) == .expense
    }

    let grouped = Dictionary(grouping: expenseTransactions) { transaction in
      TransactionCreationService.normalizedCategory(transaction.category)
    }

    let totalExpenses = expenseTransactions.reduce(0) { $0 + $1.amount }

    return grouped.map { category, transactions in
      let total = transactions.reduce(0) { $0 + $1.amount }
      return CategorySpendingReport(
        category: category,
        total: total,
        share: totalExpenses > 0 ? total / totalExpenses : 0
      )
    }
    .sorted { $0.total > $1.total }
  }

  private static func incomeExpenseReport(from transactions: [Transaction]) -> IncomeExpenseReport {
    let income = transactions
      .filter { TransactionType(coreDataValue: $0.type) == .income }
      .reduce(0) { $0 + $1.amount }

    let expenses = transactions
      .filter { TransactionType(coreDataValue: $0.type) == .expense }
      .reduce(0) { $0 + $1.amount }

    return IncomeExpenseReport(income: income, expenses: expenses, net: income - expenses)
  }

  private static func monthOverMonthReport(
    from transactions: [Transaction],
    period: ReportPeriod,
    referenceDate: Date
  ) -> MonthOverMonthReport {
    let calendar = Calendar.current
    let currentDate = period.comparisonMonthDate(referenceDate: referenceDate, calendar: calendar)
    let previousDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate

    let currentExpenses = expenses(
      from: transactions,
      in: calendar.dateInterval(of: .month, for: currentDate)
    )
    let previousExpenses = expenses(
      from: transactions,
      in: calendar.dateInterval(of: .month, for: previousDate)
    )

    return MonthOverMonthReport(
      currentMonthTitle: monthFormatter.string(from: currentDate),
      previousMonthTitle: monthFormatter.string(from: previousDate),
      currentExpenses: currentExpenses,
      previousExpenses: previousExpenses,
      difference: currentExpenses - previousExpenses
    )
  }

  private static func expenses(from transactions: [Transaction], in interval: DateInterval?) -> Double {
    guard let interval else { return 0 }

    return transactions.reduce(0) { total, transaction in
      guard
        TransactionType(coreDataValue: transaction.type) == .expense,
        let date = transaction.date,
        interval.contains(date)
      else {
        return total
      }

      return total + transaction.amount
    }
  }

  private static func savingsProgress(from goals: [SavingsGoal]) -> SavingsProgressReport {
    SavingsProgressReport(
      totalSaved: goals.reduce(0) { $0 + $1.currentAmount },
      totalTarget: goals.reduce(0) { $0 + $1.targetAmount },
      activeGoalCount: goals.filter { $0.currentAmount < $0.targetAmount }.count
    )
  }
}
