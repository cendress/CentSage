//
//  DashboardTabView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/24/23.
//

import SwiftUI

struct DashboardTabView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  var body: some View {
      TabView {
        OverviewView(context: viewContext)
          .tabItem {
            Image(systemName: "house.fill")
            Text("Overview")
          }

        TransactionsListView(context: viewContext)
          .tabItem {
            Image(systemName: "list.dash")
            Text("Transactions")
          }

        BudgetsListView(context: viewContext)
          .tabItem {
            Image(systemName: "dollarsign.circle.fill")
            Text("Budgets")
          }

        ReportsView(context: viewContext)
          .tabItem {
            Image(systemName: "chart.bar.xaxis")
            Text("Reports")
          }
      }
      .accentColor(Color("CentSageGreen"))
  }
}

#Preview {
  DashboardTabView()
}
