//
//  ContentView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var isAddNewGoalSheetPresented = false
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
                        Text("Summary")
                        Image(systemName: "chart.bar.fill")
                    }
                    .tag(0)
//                AnalysisView()
//                    .tabItem {
//                        Text("Analysis")
//                        Image(systemName: "chart.pie")
//                    }.tag(1)
                Text("")
                    .tabItem {
                        Image(systemName: "plus.circle")
                    }.tag(1)
//                SavingsView()
//                    .tabItem {
//                        Text("Transaction")
//                        Image(systemName: "tray.2")
//                    }.tag(3)
                ProfileView()
                    .tabItem {
                        Text("Profile")
                        Image(systemName: "person.crop.circle")
                    }.tag(2)
            }
            
            .onChange(of: selectedTab) { oldTab , newTab in
                if selectedTab == 1 {
                    self.isAddNewGoalSheetPresented = true
                    self.selectedTab = oldTab
                } else if (isAddNewGoalSheetPresented == false) {
                    self.selectedTab = newTab
                }
            }
            .sheet(isPresented: $isAddNewGoalSheetPresented) {
                NewSheetView()
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
