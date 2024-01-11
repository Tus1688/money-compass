//
//  SummaryView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 08/12/23.
//

import SwiftUI

struct SummaryView: View {
    @State private var showProfileSettings = false
    @State private var firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
    @State private var lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        VStack() {
            // we can't use navigationTitle as the profile settings
            // button will be pushed to top right of the screen
            HStack {
                Text("Hello, \(firstName)")
                    .font(.largeTitle.bold())
                Spacer()
                Button {
                    showProfileSettings.toggle()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle.bold())
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.top, 36)
            .padding(.horizontal)
            
            RecentTransactions()
            SavingGoalsView(fetchTrigger: $fetchTrigger)
        }
        .sheet(isPresented: $showProfileSettings) {
            NavigationStack {
                ProfileView()
                    .navigationBarItems(trailing: Button("Done") {
                        showProfileSettings = false
                    })
            }
        }
    }
}

private struct previewSummaryView: View {
    @State private var fetchTrigger = false
    var body: some View {
        SummaryView(fetchTrigger: $fetchTrigger)
    }
}

#Preview {
    previewSummaryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
