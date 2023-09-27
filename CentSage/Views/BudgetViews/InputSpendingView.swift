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
    VStack {
      TextField("Amount", text: $inputAmount)
        .keyboardType(.decimalPad)
        .padding()
      
      Button("Submit") {
        if let inputDouble = Double(inputAmount) {
          usedAmount += inputDouble
          onSave()  
          presentationMode.wrappedValue.dismiss()
        }
      }
      .padding()
    }
    .navigationBarTitle("How much did you spend?")
  }
}

