//
//  SavingsGoalsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI
import CoreData

struct SavingsGoalsListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
          entity: SavingsGoal.entity(),
          sortDescriptors: [NSSortDescriptor(keyPath: \SavingsGoal.dueDate, ascending: true)]
      ) private var goals: FetchedResults<SavingsGoal>
  
  @State private var isShowingNewGoalView = false
  
  var body: some View {
    NavigationView {
      List(goals, id: \.self) { goal in
        SavingsGoalRow(goal: goal)
      }
      .navigationTitle("Savings Goals")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            isShowingNewGoalView = true
          }, label: {
            Image(systemName: "plus")
          })
        }
      }
      .sheet(isPresented: $isShowingNewGoalView) {
        NewSavingsGoal()
          .environment(\.managedObjectContext, self.viewContext)
      }
    }
  }
}

#Preview {
  SavingsGoalsListView()
}
