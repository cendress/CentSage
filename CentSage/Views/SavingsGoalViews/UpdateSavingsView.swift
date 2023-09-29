//
//  UpdateSavingsView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/28/23.
//

import SwiftUI

struct UpdateSavingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var viewModel: SavingsGoalsViewModel
  
  @State private var savedAmount: String = ""
  
  var goal: SavingsGoal
  
  @State private var showingAlert = false
  @State private var alertMessage = ""
  
  func updateSavings() {
    guard let savedAmountDouble = Double(savedAmount), savedAmountDouble >= 0 else {
      alertMessage = "Please enter a valid positive number."
      showingAlert = true
      return
    }
    
    goal.currentAmount += savedAmountDouble
    
    do {
      try viewContext.save()
      viewModel.fetchGoals()
      presentationMode.wrappedValue.dismiss()
    } catch {
      alertMessage = "Failed to save changes: \(error.localizedDescription)"
      showingAlert = true
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Text("How much did you save?")
          .font(.largeTitle)
        
        HStack {
          Text("$")
          TextField("Amount", text: $savedAmount)
            .keyboardType(.decimalPad)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        Button("Submit", action: updateSavings)
          .font(.headline)
          .padding()
          .background(Color("CentSageGreen")) 
          .foregroundColor(.white)
          .cornerRadius(8)
      }
      .padding()
      .navigationBarTitle("Update Savings", displayMode: .inline)
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
    }
  }
}


