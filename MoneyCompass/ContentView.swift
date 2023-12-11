//
//  ContentView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    // check if user has seen onboarding and fill their personal data
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if !hasCompletedOnboarding {
            OnBoardingView(onboardingCompleted: {
                hasCompletedOnboarding = true
            })
        } else {
            TabView(selection: $selectedTab) {
                SummaryView()
                    .tabItem {
                        Text("Home")
                        Image(systemName: "chart.bar.fill")
                    }
                Text("Analysis View")
                    .tabItem {
                        Text("Analysis")
                        Image(systemName: "chart.pie")
                    }
                Text("Add new transaction")
                    .tabItem {
                        Image(systemName: "plus.circle")
                    }
               
                Text("Transaction View")
                    .tabItem {
                        Text("Transaction")
                        Image(systemName: "tray.2")
                    }
                Text("Profile View")
                    .tabItem {
                        Text("Profile")
                        Image(systemName: "person.crop.circle")
                    }
            }
            .edgesIgnoringSafeArea(.bottom)
            // development purposes only okay! (to reset userDefaults)
//                        .onAppear {
//                            let defaults = UserDefaults.standard
//                            let dictionary = defaults.dictionaryRepresentation()
//                            dictionary.keys.forEach { key in
//                                defaults.removeObject(forKey: key)
//                            }
//                        }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
