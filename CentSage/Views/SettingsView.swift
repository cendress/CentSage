//
//  SettingsView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import SwiftUI

struct SettingsView: View {
  @State private var notificationsEnabled = true
  @State private var themeSelection = 0
  
  var body: some View {
    NavigationView {
      Form {
        Toggle("Notifications", isOn: $notificationsEnabled)
        Picker("Theme", selection: $themeSelection) {
          Text("Light").tag(0)
          Text("Dark").tag(1)
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
