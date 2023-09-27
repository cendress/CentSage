//
//  ContentView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
  @EnvironmentObject var themeProvider: ThemeProvider
  @State private var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "HasCompletedOnboarding")
  
  var body: some View {
    Group {
      if hasCompletedOnboarding {
        DashboardTabView {
          hasCompletedOnboarding = false
        }
      } else {
        OnboardingView {
          UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
          hasCompletedOnboarding = true
        }
      }
    }
    .colorScheme(themeProvider.isDarkMode ? .dark : .light)
  }
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
