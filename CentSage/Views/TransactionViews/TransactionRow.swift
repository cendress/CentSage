//
//  TransactionRow.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

struct TransactionRow: View {
  var transaction: Transaction
  
  let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
  
  var body: some View {
    HStack {
      Image(systemName: icon(for: transaction.category))
        .foregroundColor(color(for: transaction.category))
        .frame(width: 30, height: 30)
        .background(color(for: transaction.category).opacity(0.2))
        .cornerRadius(8)
      
      VStack(alignment: .leading, spacing: 5) {
        Text(transaction.name ?? "Unknown name")
          .font(.headline)
        Text(transaction.category ?? "Unknown category")
          .font(.subheadline)
          .foregroundColor(color(for: transaction.category))
        if let date = transaction.date {
          Text(DateFormatter.shortDate.string(from: date))
            .font(.footnote)
            .foregroundColor(.gray)
        } else {
          Text("Unknown date")
            .font(.footnote)
            .foregroundColor(.gray)
        }
      }
      
      Spacer()
      
      Text(formatter.string(from: NSNumber(value: transaction.amount)) ?? "$0.00")
        .font(.headline)
        .foregroundColor(transaction.type == 0 ? .green : .red)
        .font(amountFont(for: transaction.amount))
    }
    .padding(10)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
  }
  
  func icon(for category: String?) -> String {
    switch category {
    case "Food":
      return "cart.fill"
    case "Home":
      return "house.fill"
    case "Work":
      return "briefcase.fill"
    case "Transportation":
      return "car.fill"
    case "Entertainment":
      return "film.fill"
    case "Leisure":
      return "sun.max.fill"
    case "Health":
      return "cross.fill"
    case "Gift":
      return "gift.fill"
    case "Shopping":
      return "bag.fill"
    case "Investment":
      return "dollarsign.circle.fill"
    default:
      return "questionmark.circle.fill"
    }
  }
  
  func color(for category: String?) -> Color {
    switch category {
    case "Food":
      return .green
    case "Home":
      return .blue
    case "Work":
      return .gray
    case "Transportation":
      return .orange
    case "Entertainment":
      return .purple
    case "Leisure":
      return .yellow
    case "Health":
      return .red
    case "Gift":
      return .pink
    case "Shopping":
      return .mint
    case "Investment":
      return .indigo
    default:
      return .secondary
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

//#Preview {
//  let sampleTransaction = PersistenceController.preview.createSampleTransaction(context: NSManagedObjectContext)
//  return TransactionRow(transaction: sampleTransaction)
//    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

