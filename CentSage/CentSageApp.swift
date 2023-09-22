//
//  CentSageApp.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

@main
struct CentSageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
