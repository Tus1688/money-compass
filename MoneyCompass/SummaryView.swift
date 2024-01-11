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
    @State private var isTransactionSheetPresented = false
    var body: some View {
        VStack{
            
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
            //                Section("Wds"){
            ////                    DailyExpensesView()
            //                    RecentTransactions()
            //
            //                }
            //                List {
            //                    Text("Daily Expenses")
            //                        .font(.title2)
            //                        .fontWeight(.bold)
            //
            //                    SavingGoalsView(fetchTrigger: $fetchTrigger)
            //                }
            List {
                AnalysisView()
                Section(header:HStack{
                    Text("Recent Transaction")
                    Spacer()
                    Button(action: {
                        isTransactionSheetPresented.toggle()
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    })
                } ) {
                    RecentTransactions()
                }
                .headerProminence(.increased)
                Section(header: Text("Saving Goals")) {
                    SavingGoalsView(fetchTrigger: $fetchTrigger)
                }
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            
            
            .sheet(isPresented: $isTransactionSheetPresented){
                TransactionView()
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
