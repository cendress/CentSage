//
//  DashboardView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

struct DashboardView: View {
  var logoutAction: () -> Void
  
  var body: some View {
    VStack {
      Text("Dashboard")
      Button("Logout") {
        logoutAction()
      }
    }
  }
}

#Preview {
  DashboardView {
    print("Logout action performed.")
  }
}
