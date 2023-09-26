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
            selectedGoal = SavingsGoal(context: viewContext)
          }, label: {
            Image(systemName: "plus")
          })
        }
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
      }
      .sheet(item: $selectedGoal, onDismiss: {
        viewModel.fetchGoals()
        if viewContext.hasChanges {
          try? viewContext.save()
        }
        selectedGoal = nil
      }) { goal in
        SavingsGoalForm(goal: goal)
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
