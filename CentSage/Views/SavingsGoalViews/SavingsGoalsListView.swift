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
      List {
        ForEach(viewModel.goals, id: \.self) { goal in
          SavingsGoalRow(goal: goal)
        }
        .onDelete(perform: viewModel.deleteGoals)
      }
        .navigationTitle("Savings Goals")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              isShowingNewGoalView = true
            }, label: {
              Image(systemName: "plus")
            })
          }
          ToolbarItem(placement: .topBarLeading) {
            EditButton()
          }
        }
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
