//
//  ContentView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
  @State private var isUserLoggedIn = false
  
  var body: some View {
    Group {
      if isUserLoggedIn {
        //DashboardView()
      } else {
        //OnboardingView()
      }
    }
  }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
