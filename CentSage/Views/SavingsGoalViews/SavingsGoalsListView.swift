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
  
  @State private var showingUpdateView = false
  @State private var refreshTrigger = false
  
  @State private var displayedGoal: SavingsGoal?
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: SavingsGoalsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        if viewModel.goals.isEmpty {
          emptyGoalsView
        } else {
          goalsListView
        }
      }
      .navigationTitle("Savings Goals")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          showingNewGoalView = true
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.accentColor)
        }
      )
      .sheet(isPresented: $showingNewGoalView) {
        NewSavingsGoal()
          .environment(\.managedObjectContext, viewContext)
      }
      .onAppear {
        viewModel.fetchGoals()
      }
      .sheet(isPresented: $showingUpdateView, onDismiss: {
        displayedGoal = nil
      }) {
        if let goal = displayedGoal {
          UpdateSavingsView(viewModel: viewModel, refreshTrigger: $refreshTrigger, goal: goal)
            .environment(\.managedObjectContext, viewContext)
        }
      }
    }
    .onChange(of: showingUpdateView) { newValue in
      if newValue {
        displayedGoal = selectedGoal
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
        .padding(.bottom, 1)
      Text("Tap on the + button to add a new goal.")
        .font(.subheadline)
        .foregroundColor(.gray)
      
      Spacer()
    }
    .padding()
  }
  
  var goalsListView: some View {
    List {
      ForEach(viewModel.goals) { goal in
        Button(action: {
          selectedGoal = goal
          showingUpdateView = true
        }) {
          SavingsGoalRow(goal: goal)
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
      }
      .onDelete(perform: viewModel.deleteGoals)
    }
    .id(refreshTrigger)
  }
}

#Preview {
  SavingsGoalsListView(context: PersistenceController.preview.container.viewContext)
}
