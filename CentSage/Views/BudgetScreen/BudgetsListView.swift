//
//  BudgetsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI
import CoreData

struct BudgetsListView: View {
  @StateObject private var viewModel: BudgetsViewModel
  
  @State private var isShowingNewBudgetView = false
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: BudgetsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        if viewModel.budgets.isEmpty {
          emptyBudgetsView
        } else {
          budgetsListView
        }
      }
      .csScreenBackground()
      .navigationTitle("Budgets")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          isShowingNewBudgetView = true
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
        }
      )
      .sheet(isPresented: $isShowingNewBudgetView) {
        NewBudgetView()
      }
      .onAppear {
        viewModel.fetchBudgets()
      }
    }
    .tint(CSColor.brandGreen)
  }
  
  var emptyBudgetsView: some View {
    CSEmptyStateView(
      systemImage: "dollarsign.circle.fill",
      title: "No budgets yet!",
      message: "Tap the button to add a budget and keep spending on track.",
      buttonTitle: "Add Budget",
      buttonSystemImage: "plus",
      action: {
        isShowingNewBudgetView = true
      }
    )
  }
  
  var budgetsListView: some View {
    List {
      ForEach(viewModel.budgets, id: \.self) { budget in
        BudgetRow(budget: budget)
          .listRowInsets(EdgeInsets(top: CSSpacing.xs, leading: 0, bottom: CSSpacing.xs, trailing: 0))
          .csListRowStyle()
      }
      .onDelete(perform: viewModel.deleteBudgets)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(CSColor.background)
  }
}

#Preview {
  BudgetsListView(context: PersistenceController.preview.container.viewContext)
}
