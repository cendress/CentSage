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
  @StateObject private var viewModel: SavingsGoalsViewModel
  
  @State private var isShowingNewGoalView = false
  @State private var isShowingEditGoalView = false
  @State private var selectedGoal: SavingsGoal?
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: SavingsGoalsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.goals, id: \.self) { goal in
          Button(action: {
            selectedGoal = goal
            isShowingEditGoalView = true
          }) {
            SavingsGoalRow(goal: goal)
          }
          .buttonStyle(PlainButtonStyle()) 
        }
        .onDelete(perform: viewModel.deleteGoals)
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
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
      }
      .sheet(isPresented: $isShowingNewGoalView) {
        SavingsGoalForm()
          .environment(\.managedObjectContext, viewContext)
      }
      .sheet(isPresented: $isShowingEditGoalView, onDismiss: {
        selectedGoal = nil
      }) {
        if let goal = selectedGoal {
          SavingsGoalForm(goal: goal)
            .environment(\.managedObjectContext, viewContext)
        }
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
