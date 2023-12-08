//
//  ContentView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            SummaryView()
                .tabItem {
                    Text("Summary")
                    Image(systemName: "chart.bar.fill")
                }
            Text("Add new transaction")
                .tabItem {
                    Text("Add")
                    Image(systemName: "plus.circle.fill")
                }
            Text("Analysis View")
                .tabItem {
                    Text("Analysis")
                    Image(systemName: "chart.pie")
                }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
