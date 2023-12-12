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

#Preview {
    SummaryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
