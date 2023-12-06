//
//  MoneyCompassApp.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 06/12/23.
//

import SwiftUI

@main
struct MoneyCompassApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
