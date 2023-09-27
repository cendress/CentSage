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
  @State private var showingNewGoalView = false
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: SavingsGoalsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        if viewModel.goals.isEmpty {
          emptyGoalsView
          Spacer()
        } else {
          goalsListView
        }
      }
      .navigationTitle("Savings Goals")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            showingNewGoalView = true
          }, label: {
            Image(systemName: "plus")
          })
        }
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
      }
      .sheet(isPresented: $showingNewGoalView) {
        NewSavingsGoal()
          .environment(\.managedObjectContext, viewContext)
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
  
  var emptyGoalsView: some View {
    VStack {
      Spacer()
      
      Image(systemName: "plus.circle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .foregroundColor(.gray)
        .padding()
      Text("No goals yet!")
        .font(.headline)
      Text("Tap on the + button to add a new goal.")
        .font(.subheadline)
        .foregroundColor(.gray)
      
      Spacer()
    }
    .padding()
  }
  
  var goalsListView: some View {
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
  }
}

#Preview {
  SavingsGoalsListView(context: PersistenceController.preview.container.viewContext)
}
