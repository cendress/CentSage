//
//  ReportsView.swift
//  CentSage
//

import SwiftUI

struct ReportsView: View {
  var body: some View {
    NavigationView {
      VStack {
        CSEmptyStateView(
          systemImage: "chart.bar.xaxis",
          title: "Reports",
          message: "Monthly trends will appear here as CentSage collects more of your financial history."
        )
      }
      .csScreenBackground()
      .navigationTitle("Reports")
    }
    .tint(CSColor.brandGreen)
  }
}

#Preview {
  ReportsView()
}
