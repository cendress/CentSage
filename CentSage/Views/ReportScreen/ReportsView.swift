//
//  ReportsView.swift
//  CentSage
//

import CoreData
import SwiftUI

struct ReportsView: View {
  @StateObject private var viewModel: ReportsViewModel

  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: ReportsViewModel(context: context))
  }

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: CSSpacing.lg) {
          periodPicker

          incomeExpensesCard(viewModel.snapshot.incomeExpense)
          SpendingByCategorySection(categories: viewModel.snapshot.categories)
          MonthOverMonthSection(report: viewModel.snapshot.monthOverMonth)
        }
        .padding(CSSpacing.md)
      }
      .csScreenBackground()
      .navigationTitle("Reports")
      .onAppear {
        viewModel.refresh()
      }
    }
    .tint(CSColor.brandGreen)
  }

  private var periodPicker: some View {
    Picker("Period", selection: $viewModel.selectedPeriod) {
      ForEach(ReportPeriod.allCases) { period in
        Text(period.title).tag(period)
      }
    }
    .pickerStyle(.segmented)
  }

  private func incomeExpensesCard(_ report: IncomeExpenseReport) -> some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Income vs Expenses")

        if !report.hasTransactions {
          Text("Add transactions to see your income, spending, and net amount.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
        } else {
          HStack(alignment: .firstTextBaseline) {
            reportMetric(title: "Income", amount: report.income, color: CSColor.income)

            Spacer()

            reportMetric(title: "Expenses", amount: report.expenses, color: CSColor.expense)
          }

          Divider()
            .background(CSColor.divider)

          HStack(alignment: .firstTextBaseline) {
            Text("Net")
              .font(CSFont.headline)
              .foregroundStyle(CSColor.primaryText)

            Spacer()

            CSAmountText(
              amount: report.net,
              size: .medium,
              color: report.net >= 0 ? CSColor.income : CSColor.expense
            )
          }
        }
      }
    }
  }

  private func reportMetric(title: String, amount: Double, color: Color) -> some View {
    VStack(alignment: .leading, spacing: CSSpacing.xxs) {
      Text(title)
        .font(CSFont.caption)
        .foregroundStyle(CSColor.secondaryText)

      CSAmountText(amount: amount, size: .small, color: color)
    }
  }
}

#Preview {
  ReportsView(context: PersistenceController.preview.container.viewContext)
}
