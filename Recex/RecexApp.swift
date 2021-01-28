//
//  RecexApp.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/23/20.
//

import SwiftUI
import PromiseKit

//Main starting view for the app
@main
struct RecexApp: App {
    let persistenceController = PersistenceController.shared

    //opens the main view of the app
    var body: some Scene {
        WindowGroup {
           ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
