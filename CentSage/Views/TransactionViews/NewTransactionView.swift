//
//  NewTransactionView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import CoreData
import SwiftUI

struct NewTransactionView: View {
  var body: some View {
    TransactionFormView()
  }
}

#Preview {
  NewTransactionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
