//
//  DashboardTabView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI

struct DashboardTabView: View {
  var logoutAction: () -> Void
  
  var body: some View {
    TabView {
      DashboardView(logoutAction: logoutAction)
        .tabItem {
          Image(systemName: "house.fill")
          Text("Home")
        }
      
      TransactionsListView()
        .tabItem {
          Image(systemName: "list.dash")
          Text("Transactions")
        }
      
      SavingsGoalsListView()
        .tabItem {
          Image(systemName: "star.fill")
          Text("Savings Goals")
        }
      
      BudgetsListView()
        .tabItem {
          Image(systemName: "dollarsign.circle.fill")
          Text("Budget")
        }
    }
  }
}

#Preview {
  DashboardTabView {
    print("Logout action performed")
  }
}
