//
//  NewBudgetView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/23/23.
//

import SwiftUI
import CoreData

struct NewBudgetView: View {
  var body: some View {
    BudgetFormView()
  }
}

#Preview {
  NewBudgetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
