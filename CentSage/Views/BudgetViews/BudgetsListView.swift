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
      ZStack {
        Color("Background")
          .ignoresSafeArea()
        VStack {
          if viewModel.budgets.isEmpty {
            emptyBudgetsView
          } else {
            budgetsListView
          }
        }
      }
      .navigationTitle("Budgets")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          isShowingNewBudgetView = true
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.accentColor)
        }
      )
      .sheet(isPresented: $isShowingNewBudgetView) {
        NewBudgetView()
          .environment(\.managedObjectContext, viewContext)
      }
      .onAppear {
        viewModel.fetchBudgets()
      }
    }
    .accentColor(Color("CentSageGreen"))
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
        .padding(.bottom, 1)
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
          .listRowBackground(Color("RowBackground"))
      }
      .onDelete(perform: viewModel.deleteBudgets)
    }
    .listStyle(InsetGroupedListStyle())
  }
}

#Preview {
  BudgetsListView(context: PersistenceController.preview.container.viewContext)
}
