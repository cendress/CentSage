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
      VStack {
        if viewModel.budgets.isEmpty {
          emptyBudgetsView
        } else {
          budgetsListView
        }
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
  
  var emptyBudgetsView: some View {
    VStack {
      Spacer()
      
      Image(systemName: "plus.circle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .foregroundColor(.gray)
        .padding()
      Text("No budgets yet!")
        .font(.headline)
      Text("Tap on the + button to add a new budget.")
        .font(.subheadline)
        .foregroundColor(.gray)
      
      Spacer()
    }
    .padding()
  }
  
  var budgetsListView: some View {
    List {
      ForEach(viewModel.budgets, id: \.self) { budget in
        BudgetRow(budget: budget)
      }
      .onDelete(perform: viewModel.deleteBudgets)
    }
  }
}

#Preview {
  BudgetsListView(context: PersistenceController.preview.container.viewContext)
}
