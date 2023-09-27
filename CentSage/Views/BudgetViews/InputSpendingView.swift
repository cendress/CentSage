//
//  InputSpendingView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/27/23.
//

import SwiftUI

struct InputSpendingView: View {
  @Binding var usedAmount: Double
  @State private var inputAmount: String = ""
  @Environment(\.presentationMode) var presentationMode
  var onSave: () -> Void
  
  var body: some View {
    NavigationView {
      VStack {
        Text("How much did you spend?")
          .font(.largeTitle)
        
        HStack {
          Text("$")
          TextField("Amount", text: $inputAmount)
            .keyboardType(.decimalPad)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        Button("Submit") {
          if let inputDouble = Double(inputAmount) {
            usedAmount += inputDouble
            onSave()
            presentationMode.wrappedValue.dismiss()
          }
        }
        .padding()
        .background(Color("CentSageGreen"))
        .foregroundColor(.white)
        .cornerRadius(8)
      }
      .padding()
      .navigationBarTitle("Input Spending", displayMode: .inline)
    }
  }
}


