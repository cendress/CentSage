//
//  RecentTransactionsCard.swift
//  CentSage
//

import SwiftUI

struct RecentTransactionsCard: View {
  let transactions: [Transaction]

  var body: some View {
    CSCard {
      VStack(alignment: .leading, spacing: CSSpacing.md) {
        CSSectionHeader(title: "Recent Transactions")

        if transactions.isEmpty {
          Text("No transactions yet. Add one to start seeing your month clearly.")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
        } else {
          VStack(spacing: CSSpacing.sm) {
            ForEach(Array(transactions.enumerated()), id: \.element.objectID) { index, transaction in
              transactionRow(transaction)

              if index < transactions.count - 1 {
                Divider()
                  .background(CSColor.divider)
              }
            }
          }
        }
      }
    }
  }

  private func transactionRow(_ transaction: Transaction) -> some View {
    HStack(alignment: .top, spacing: CSSpacing.sm) {
      Image(systemName: TransactionType(coreDataValue: transaction.type) == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
        .font(.headline)
        .foregroundStyle(amountColor(for: transaction))
        .frame(width: 34, height: 34)
        .background(amountColor(for: transaction).opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

      VStack(alignment: .leading, spacing: CSSpacing.xxs) {
        Text(title(for: transaction))
          .font(CSFont.subheadline)
          .foregroundStyle(CSColor.primaryText)

        if let date = transaction.date {
          Text(date.csShortFormatted)
            .font(CSFont.footnote)
            .foregroundStyle(CSColor.tertiaryText)
        }

        if let note = transaction.note?.trimmingCharacters(in: .whitespacesAndNewlines), !note.isEmpty {
          Text(note)
            .font(CSFont.footnote)
            .foregroundStyle(CSColor.secondaryText)
            .lineLimit(2)
        }
      }

      Spacer()

      CSAmountText(
        amount: signedAmount(for: transaction),
        size: .small,
        color: amountColor(for: transaction),
        showsSign: TransactionType(coreDataValue: transaction.type) == .income
      )
    }
  }

  private func title(for transaction: Transaction) -> String {
    let name = transaction.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !name.isEmpty {
      return name
    }

    let category = transaction.category?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return category.isEmpty ? "Transaction" : category
  }

  private func signedAmount(for transaction: Transaction) -> Double {
    TransactionType(coreDataValue: transaction.type) == .income ? transaction.amount : -transaction.amount
  }

  private func amountColor(for transaction: Transaction) -> Color {
    TransactionType(coreDataValue: transaction.type) == .income ? CSColor.income : CSColor.expense
  }
}
