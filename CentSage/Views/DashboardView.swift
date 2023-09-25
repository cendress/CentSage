//
//  DashboardView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

struct DashboardView: View {
  var logoutAction: () -> Void
  @StateObject private var viewModel = TransactionsViewModel(context: PersistenceController.shared.container.viewContext)
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          Text("Dashboard")
            .font(.largeTitle)
            .padding()
          
          // Assume BudgetSummary is a custom view you create to show budget information
          //BudgetSummary()
            .padding()
          
          // Assume RecentTransactions is a custom view you create to show recent transactions
          RecentTransactionsView(viewModel: viewModel)
            .padding()
          
          // ... Other dashboard elements
          
          Button("Logout", action: logoutAction)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  DashboardView {
    print("Logout action performed.")
  }
}
