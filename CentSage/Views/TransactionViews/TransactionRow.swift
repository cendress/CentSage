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
    HStack {
      VStack(alignment: .leading) {
        Text(transaction.name ?? "Unknown name")
          .font(.headline)
        Text(transaction.category ?? "Unknown category")
        
        Text(transaction.date != nil ? "\(DateFormatter.shortDate.string(from: transaction.date!))" : "Unknown date")
          .font(.subheadline)
      }
      
      Spacer()
  
        Text(String(format: "$%.2f", transaction.amount))
          .font(.headline)
          .foregroundColor(transaction.type == 0 ? .green : .red)
          .font(amountFont(for: transaction.amount))
    }
  }
  
  func amountFont(for amount: Double) -> Font {
    if amount < 10 {
      return .system(size: 14, weight: .regular)
    } else if amount < 100 {
      return .system(size: 16, weight: .medium)
    } else {
      return .system(size: 18, weight: .bold)
    }
  }
}

#Preview {
    let sampleTransaction = PersistenceController.preview.createSampleTransaction()
    return TransactionRow(transaction: sampleTransaction)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

