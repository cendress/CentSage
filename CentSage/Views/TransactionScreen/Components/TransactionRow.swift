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
    CSCard(padding: CSSpacing.sm) {
      HStack(spacing: CSSpacing.sm) {
        Image(systemName: icon(for: transaction.category))
          .font(.headline)
          .foregroundStyle(color(for: transaction.category))
          .frame(width: 38, height: 38)
          .background(color(for: transaction.category).opacity(0.14))
          .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

        VStack(alignment: .leading, spacing: CSSpacing.xxs) {
          Text(displayTitle)
            .font(CSFont.headline)
            .foregroundStyle(CSColor.primaryText)

          Text(transaction.category ?? "Unknown category")
            .font(CSFont.subheadline)
            .foregroundStyle(color(for: transaction.category))

          if let date = transaction.date {
            Text(date.csShortFormatted)
              .font(CSFont.footnote)
              .foregroundStyle(CSColor.tertiaryText)
          } else {
            Text("Unknown date")
              .font(CSFont.footnote)
              .foregroundStyle(CSColor.tertiaryText)
          }

          if let note = transaction.note, !note.isEmpty {
            Text(note)
              .font(CSFont.footnote)
              .foregroundStyle(CSColor.secondaryText)
              .lineLimit(2)
          }
        }

        Spacer()

        CSAmountText(
          amount: transaction.amount,
          size: .small,
          color: transaction.type == 0 ? CSColor.expense : CSColor.income
        )
      }
    }
  }

  private var displayTitle: String {
    let name = transaction.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !name.isEmpty {
      return name
    }

    let category = transaction.category?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !category.isEmpty && category != TransactionCreationService.uncategorizedCategory {
      return "\(category) spending"
    }

    return "Quick entry"
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
      return CSColor.positive
    case "Home":
      return CSColor.info
    case "Work":
      return CSColor.secondaryText
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
      return CSColor.secondaryText
    }
  }
}
