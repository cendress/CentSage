//
//  TransactionRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

struct TransactionRow: View {
  var transaction: Transaction
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(transaction.name ?? "Unknown name")
      Text(transaction.category ?? "Unknown category")
      Text(String(format: "$%.2f", transaction.amount))
        .font(.headline)
        .foregroundColor(transaction.type == 0 ? .green : .red)
      Text(transaction.date != nil ? "\(DateFormatter.shortDate.string(from: transaction.date!))" : "Unknown date")

    }
  }
}

#Preview {
    let sampleTransaction = PersistenceController.preview.createSampleTransaction()
    return TransactionRow(transaction: sampleTransaction)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

