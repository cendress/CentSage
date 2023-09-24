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
      List {
        ForEach(viewModel.budgets, id: \.self) { budget in
          BudgetRow(budget: budget)
        }
        .onDelete(perform: viewModel.deleteBudgets)
      }
      .navigationTitle("Budgets")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            isShowingNewBudgetView = true
          }, label: {
            Image(systemName: "plus")
          })
        }
        ToolbarItem(placement: .topBarLeading) {
          EditButton()
        }
      }
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
