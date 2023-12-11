//
//  SummaryView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 08/12/23.
//

import SwiftUI

struct SummaryView: View {
    @State private var showProfileSettings = false
    private var firstName: String {
        if let name = UserDefaults.standard.string(forKey: "firstName") {
            return name
        } else {
            return "User" // Default value if first name is not set in UserDefaults
        }
    }
    
    var body: some View {
        NavigationStack{
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
                BalanceView()
                RecentTransactions()
                SavingGoalsView()
            }
            .sheet(isPresented: $showProfileSettings) {
                NavigationStack {
                    Text("Profile view")
                        .navigationBarItems(trailing: Button("Done") {
                            showProfileSettings = false
                        })
                }
            }
        }
    }
}

#Preview {
    SummaryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
