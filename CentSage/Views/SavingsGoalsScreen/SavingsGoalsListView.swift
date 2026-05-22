//
//  SavingsGoalsListView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI
import CoreData

struct SavingsGoalsListView: View {
  @StateObject private var viewModel: SavingsGoalsViewModel
  @EnvironmentObject var themeProvider: ThemeProvider

  @State private var showingNewGoalView = false
  @State private var selectedGoal: SavingsGoal?
  @State private var refreshTrigger = false

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
      .csScreenBackground()
      .navigationTitle("Goals")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          showingNewGoalView = true
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
        }
      )
      .sheet(isPresented: $showingNewGoalView) {
        NewSavingsGoal {
          viewModel.fetchGoals()
        }
      }
      .onAppear {
        viewModel.fetchGoals()
      }
      .sheet(item: $selectedGoal, onDismiss: {
        viewModel.fetchGoals()
      }) { selectedGoal in
        UpdateSavingsView(viewModel: viewModel, refreshTrigger: $refreshTrigger, goal: selectedGoal)
          .environment(\.colorScheme, themeProvider.isDarkMode ? .dark : .light)
      }
    }
    .tint(CSColor.brandGreen)
  }

  var emptyGoalsView: some View {
    CSEmptyStateView(
      systemImage: "star.fill",
      title: "No goals yet!",
      message: "Create a goal to see a weekly savings plan and track your progress.",
      buttonTitle: "Add Goal",
      buttonSystemImage: "plus",
      action: {
        showingNewGoalView = true
      }
    )
  }

  var goalsListView: some View {
    List {
      ForEach(viewModel.goals) { goal in
        if let index = viewModel.goals.firstIndex(of: goal) {
          Button(action: {
            selectedGoal = goal
          }) {
            SavingsGoalRow(goal: $viewModel.goals[index])
          }
          .buttonStyle(.plain)
          .listRowInsets(EdgeInsets(top: CSSpacing.xs, leading: CSSpacing.md, bottom: CSSpacing.xs, trailing: CSSpacing.md))
          .csListRowStyle()
        }
      }
      .onDelete(perform: viewModel.deleteGoals)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(CSColor.background)
  }
}

#Preview {
  SavingsGoalsListView(context: PersistenceController.preview.container.viewContext)
}
