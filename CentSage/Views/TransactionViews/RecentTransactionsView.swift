//
//  RecentTransactionsView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import SwiftUI

struct RecentTransactionsView: View {
  @ObservedObject var viewModel: TransactionsViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Recent Transactions")
        .font(.title)
        .bold()
        .padding(.horizontal)
      
      List(viewModel.recentTransactions, id: \.self) { transaction in
        TransactionRow(transaction: transaction)
      }
    }
    .onAppear {
      viewModel.fetchRecentTransactions(limit: 5)
    }
  }
}
