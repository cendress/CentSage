//
//  SettingsView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import CoreData
import SwiftUI

struct SettingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var themeProvider: ThemeProvider
  
  @State private var showingAlert = false
  
  var body: some View {
    NavigationView {
      Form {
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
        
        Section {
          Button(action: {
            showingAlert = true
          }) {
            Text("Delete My Data")
              .foregroundColor(.red)
          }
          .alert(isPresented: $showingAlert) {
            Alert(title: Text("Are you sure?"),
                  message: Text("This will permanently delete all your data. This action can't be undone."),
                  primaryButton: .destructive(Text("Delete")) {
              deleteUserData()
            },
                  secondaryButton: .cancel()
            )
          }
        } header: {
          Text("Data Management")
        }
      }
      .navigationTitle("Settings")
    }
  }
  
  func deleteUserData() {
    let entities = ["Budget", "SavingsGoal", "Transaction"]
    
    for entity in entities {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      do {
        try viewContext.execute(batchDeleteRequest)
      } catch {
        
      }
    }
    
    do {
      try viewContext.save()
    } catch {
     
    }
  }
}

#Preview {
  SettingsView()
}
