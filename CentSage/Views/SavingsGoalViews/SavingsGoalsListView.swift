//
//  SavingsGoalsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import CoreData
import SwiftUI

struct SavingsGoalsListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @StateObject private var viewModel: SavingsGoalsViewModel
  
  @State private var isShowingNewGoalView = false
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: SavingsGoalsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      List(viewModel.goals, id: \.self) { goal in
        SavingsGoalRow(goal: goal)
      }
      .navigationTitle("Savings Goals")
      .navigationBarItems(trailing: Button(action: {
        isShowingNewGoalView = true
      }) {
        Image(systemName: "plus")
      })
      .sheet(isPresented: $isShowingNewGoalView) {
        NewSavingsGoal()
          .environment(\.managedObjectContext, viewContext)
      }
      .onAppear {
        viewModel.fetchGoals()
      }
    }
  }
}

#Preview {
  SavingsGoalsListView(context: PersistenceController.preview.container.viewContext)
}
