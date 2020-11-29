//
//  RecexApp.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/23/20.
//

import SwiftUI
import PromiseKit

@main
struct RecexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
