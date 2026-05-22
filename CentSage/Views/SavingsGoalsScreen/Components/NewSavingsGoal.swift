//
//  NewSavingsGoal.swift
//  CentSage
//

import SwiftUI

struct NewSavingsGoal: View {
  var onSave: () -> Void = {}

  var body: some View {
    GoalFormView(onSave: onSave)
  }
}

#Preview {
  NewSavingsGoal()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
