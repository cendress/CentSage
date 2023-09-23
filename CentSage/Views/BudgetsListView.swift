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
  @FetchRequest(
    entity: Budget.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Budget.startDate, ascending: false)]
  ) private var budgets: FetchedResults<Budget>
  
  @State private var isShowingNewBudgetView = false
  
  var body: some View {
    NavigationView {
      List(budgets, id: \.self) { budget in
        BudgetRow(budget: budget)
      }
      .navigationTitle("Budgets")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            isShowingNewBudgetView = true
          }, label: {
            Image(systemName: "plus")
          })
        }
      }
      .sheet(isPresented: $isShowingNewBudgetView) {
        //NewBudgetView()
        //.environment(\.managedObjectContext, self.viewContext)
      }
    }
  }
}

#Preview {
  BudgetsListView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
