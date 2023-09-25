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
