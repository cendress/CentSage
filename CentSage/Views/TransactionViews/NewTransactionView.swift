//
//  NewTransactionView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import CoreData
import SwiftUI

struct NewTransactionView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var name = ""
  @State private var amount = ""
  @State private var selectedSegment = 0
  @State private var selectedCategoryIndex = 0
  @State private var note = ""
  
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the transaction. Please try again."
  
  let categories = ["Food", "Home", "Work", "Transportation", "Entertainment", "Leisure", "Health", "Gift", "Shopping", "Investment", "Other"]
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Name", text: $name)
        
        HStack {
          Text("$")
          TextField("Amount", text: $amount)
            .keyboardType(.decimalPad)
        }
        
        Picker("Type", selection: $selectedSegment) {
          Text("Income").tag(0)
          Text("Expense").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        Picker("Category", selection: $selectedCategoryIndex) {
          ForEach(Array(categories.indices), id: \.self) { index in
            Text(self.categories[index]).tag(index)
          }
        }
        
        TextField("Note", text: $note)
      }
      .navigationTitle("Add Transaction")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveTransaction()
          }
        }
      }
      .alert(isPresented: $showErrorAlert) {
        Alert(
          title: Text("Saving Error"),
          message: Text(errorMessage),
          dismissButton: .default(Text("OK"))
        )
      }
    }
  }
  
  private func saveTransaction() {
    guard let amountDouble = Double(self.amount), !self.name.isEmpty else {
      self.errorMessage = "Please fill out all fields correctly."
      self.showErrorAlert = true
      return
    }
    
    let newTransaction = Transaction(context: viewContext)
    newTransaction.name = self.name
    newTransaction.amount = amountDouble
    newTransaction.type = Int16(self.selectedSegment)
    newTransaction.category = self.categories[selectedCategoryIndex]
    newTransaction.note = self.note
    newTransaction.date = Date()
    newTransaction.id = UUID()
    
    do {
      try viewContext.save()
      dismiss()
    } catch {
      let nsError = error as NSError
      print("Unresolved error \(nsError), \(nsError.userInfo)")
      self.errorMessage = "There was a problem saving the transaction. Please try again."
      self.showErrorAlert = true
    }
  }
}

#Preview {
  NewTransactionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
