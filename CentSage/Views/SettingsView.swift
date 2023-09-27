//
//  SettingsView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var themeProvider: ThemeProvider
  @State private var notificationsEnabled = true
  
  var body: some View {
    NavigationView {
      Form {
        Toggle("Notifications", isOn: $notificationsEnabled)
        
        Picker("Theme", selection: $themeProvider.isDarkMode) {
          Text("Light").tag(false)
          Text("Dark").tag(true)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        Section {
          NavigationLink(destination: Text("Terms of Service")) {
            Text("Terms of Service")
          }
          NavigationLink(destination: Text("Privacy Policy")) {
            Text("Privacy Policy")
          }
        } header: {
          Text("Legal")
        }
      }
      .navigationTitle("Settings")
    }
  }
}

#Preview {
  SettingsView()
}
