//
//  OverviewView.swift
//  CentSage
//

import CoreData
import SwiftUI

struct OverviewView: View {
  @StateObject private var viewModel: OverviewViewModel
  @State private var activeSheet: OverviewSheet?

  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: OverviewViewModel(context: context))
  }

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: CSSpacing.lg) {
          header

          MonthlySummaryCard(summary: viewModel.monthlySummary)
          NextBestActionCard(action: viewModel.nextBestAction)
          BudgetSummaryCard(summary: viewModel.budgetSummary)
          RecentTransactionsCard(transactions: viewModel.recentTransactions)
          QuickActionsCard(
            addSpending: startQuickSpending,
            addTransaction: { activeSheet = .transaction },
            addBudget: { activeSheet = .budget }
          )
        }
        .padding(CSSpacing.md)
      }
      .csScreenBackground()
      .navigationBarHidden(true)
      .onAppear {
        viewModel.refresh()
      }
      .sheet(item: $activeSheet, onDismiss: {
        viewModel.refresh()
      }) { sheet in
        sheetContent(for: sheet)
      }
    }
    .tint(CSColor.brandGreen)
  }

  private var header: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading, spacing: CSSpacing.xxs) {
        Text("Overview")
          .font(CSFont.largeTitle)
          .foregroundStyle(CSColor.primaryText)

        Text(viewModel.monthTitle)
          .font(CSFont.callout)
          .foregroundStyle(CSColor.secondaryText)
      }

      Spacer()

      Button {
        activeSheet = .settings
      } label: {
        Image(systemName: "gearshape.fill")
          .font(.headline)
          .foregroundStyle(CSColor.primaryText)
          .frame(width: 42, height: 42)
          .background(CSColor.secondaryBackground)
          .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))
      }
      .accessibilityLabel("Settings")
    }
  }

  @ViewBuilder
  private func sheetContent(for sheet: OverviewSheet) -> some View {
    switch sheet {
    case .settings:
      SettingsView()
    case .chooseBudget:
      BudgetSelectionSheet(
        budgets: viewModel.budgets,
        onSelectBudget: { budget in
          replaceActiveSheet(with: .quickSpending(budget))
        },
        onAddBudget: {
          replaceActiveSheet(with: .budget)
        }
      )
    case .quickSpending(let budget):
      QuickSpendingEntryView(budget: budget) {
        viewModel.refresh()
      }
    case .transaction:
      TransactionFormView {
        viewModel.refresh()
      }
    case .budget:
      BudgetFormView {
        viewModel.refresh()
      }
    }
  }

  private func startQuickSpending() {
    if viewModel.budgets.count == 1, let budget = viewModel.budgets.first {
      activeSheet = .quickSpending(budget)
    } else {
      activeSheet = .chooseBudget
    }
  }

  private func replaceActiveSheet(with sheet: OverviewSheet) {
    activeSheet = nil

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      activeSheet = sheet
    }
  }
}

private enum OverviewSheet: Identifiable {
  case settings
  case chooseBudget
  case quickSpending(Budget)
  case transaction
  case budget

  var id: String {
    switch self {
    case .settings:
      return "settings"
    case .chooseBudget:
      return "chooseBudget"
    case .quickSpending(let budget):
      return "quickSpending-\(budget.objectID.uriRepresentation().absoluteString)"
    case .transaction:
      return "transaction"
    case .budget:
      return "budget"
    }
  }
}

private struct BudgetSelectionSheet: View {
  let budgets: [Budget]
  let onSelectBudget: (Budget) -> Void
  let onAddBudget: () -> Void

  var body: some View {
    NavigationView {
      Group {
        if budgets.isEmpty {
          CSEmptyStateView(
            systemImage: "dollarsign.circle.fill",
            title: "No budgets yet",
            message: "Add a budget first, then quick spending can stay one tap away.",
            buttonTitle: "Add Budget",
            buttonSystemImage: "plus",
            action: onAddBudget
          )
        } else {
          List {
            ForEach(budgets, id: \.self) { budget in
              Button {
                onSelectBudget(budget)
              } label: {
                HStack(spacing: CSSpacing.sm) {
                  Image(systemName: "dollarsign.circle.fill")
                    .font(.headline)
                    .foregroundStyle(CSColor.budget)
                    .frame(width: 36, height: 36)
                    .background(CSColor.budget.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

                  VStack(alignment: .leading, spacing: CSSpacing.xxs) {
                    Text(budget.name ?? "Budget")
                      .font(CSFont.headline)
                      .foregroundStyle(CSColor.primaryText)

                    Text(BudgetCalculationService.category(for: budget))
                      .font(CSFont.footnote)
                      .foregroundStyle(CSColor.secondaryText)
                  }

                  Spacer()

                  CSAmountText(amount: budget.amount, size: .small)
                }
              }
              .buttonStyle(.plain)
              .listRowInsets(EdgeInsets(top: CSSpacing.xs, leading: CSSpacing.md, bottom: CSSpacing.xs, trailing: CSSpacing.md))
              .csListRowStyle()
            }
          }
          .listStyle(.plain)
          .scrollContentBackground(.hidden)
          .background(CSColor.background)
        }
      }
      .csScreenBackground()
      .navigationTitle("Add Spending")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  OverviewView(context: PersistenceController.preview.container.viewContext)
}
