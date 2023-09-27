//
//  DashboardTabView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI

struct DashboardTabView: View {
  @Environment(\.managedObjectContext) private var viewContext
  var logoutAction: () -> Void
  
  var body: some View {
    TabView {
      DashboardView(logoutAction: logoutAction)
        .tabItem {
          Image(systemName: "house.fill")
          Text("Home")
        }
      
      TransactionsListView(context: viewContext)
        .tabItem {
          Image(systemName: "list.dash")
          Text("Transactions")
        }
      
      SavingsGoalsListView(context: viewContext)
        .tabItem {
          Image(systemName: "star.fill")
          Text("Savings Goals")
        }
      
      BudgetsListView(context: viewContext)
        .tabItem {
          Image(systemName: "dollarsign.circle.fill")
          Text("Budgets")
        }
      
      SettingsView()
        .tabItem {
          Image(systemName: "gearshape")
          Text("Settings")
        }
    }
  }
}

#Preview {
  DashboardTabView {
    print("Logout action performed")
  }
}
