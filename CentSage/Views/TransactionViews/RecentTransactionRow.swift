//
//  RecentTransactionRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import SwiftUI

struct RecentTransactionRow: View {
  var transaction: Transaction
  
  var body: some View {
    HStack {
      Text(transaction.name ?? "Unknown Transaction")
      Spacer()
      Text("\(transaction.amount, specifier: "%.2f")")
    }
  }
}
