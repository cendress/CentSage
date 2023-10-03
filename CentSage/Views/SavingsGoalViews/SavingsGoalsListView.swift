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
        } else {
          List {
            ForEach(viewModel.goals) { goal in
              Button(action: {
                selectedGoal = goal
              }) {
                  SavingsGoalRow(goal: $viewModel.goals[viewModel.goals.firstIndex(of: goal)!])
                  .padding()
              }
              .buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: viewModel.deleteGoals)
          }
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
            .frame(width: 30, height: 30)
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
      .sheet(item: $selectedGoal, onDismiss: {
        viewModel.fetchGoals()
      }) { selectedGoal in
        UpdateSavingsView(viewModel: viewModel, refreshTrigger: $refreshTrigger, goal: selectedGoal)
          .environment(\.managedObjectContext, viewContext)
          .environment(\.colorScheme, themeProvider.isDarkMode ? .dark : .light)
      }
    }
  }
}

#Preview {
  SavingsGoalsListView(context: PersistenceController.preview.container.viewContext)
}
