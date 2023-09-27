//
//  CentSageApp.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

@main
struct CentSageApp: App {
  let persistenceController = PersistenceController.shared
  @StateObject var themeProvider = ThemeProvider()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(themeProvider)
    }
  }
}
