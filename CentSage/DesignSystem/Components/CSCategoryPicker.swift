//
//  CSCategoryPicker.swift
//  CentSage
//

import SwiftUI

struct CSCategoryPicker: View {
  static let transactionCategories = [
    "Food",
    "Home",
    "Work",
    "Transportation",
    "Entertainment",
    "Leisure",
    "Health",
    "Gift",
    "Shopping",
    "Investment",
    "Other"
  ]
  
  let title: String
  let categories: [String]
  @Binding var selection: String
  var includesAllOption = false
  
  private var options: [String] {
    includesAllOption ? ["All"] + categories : categories
  }
  
  var body: some View {
    Picker(title, selection: $selection) {
      ForEach(options, id: \.self) { category in
        Text(category).tag(category)
      }
    }
    .pickerStyle(.menu)
    .font(CSFont.callout)
    .tint(CSColor.brandGreen)
  }
}
