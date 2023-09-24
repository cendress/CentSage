//
//  BudgetsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI
import CoreData

struct BudgetsListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @StateObject private var viewModel: BudgetsViewModel
  
  @State private var isShowingNewBudgetView = false
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: BudgetsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      List(viewModel.budgets, id: \.self) { budget in
        BudgetRow(budget: budget)
      }
      .navigationTitle("Budgets")
      .navigationBarItems(trailing: Button(action: {
        isShowingNewBudgetView = true
      }) {
        Image(systemName: "plus")
      })
      .sheet(isPresented: $isShowingNewBudgetView) {
        NewBudgetView()
          .environment(\.managedObjectContext, viewContext)
      }
      .onAppear {
        viewModel.fetchBudgets()
      }
    }
  }
}

#Preview {
  BudgetsListView(context: PersistenceController.preview.container.viewContext)
}
