//
//  TransactionView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 15/12/23.
//

import SwiftUI

struct Saving: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var progress: Double
}

struct SavingsView: View {
    
    var Savings: [Saving] = [
        Saving(name: "Emergency Fund", amount: 1000, progress: 0.3),
        Saving(name: "Holiday", amount: 1000, progress: 0.5),
        Saving(name: "New Car", amount: 1000, progress: 0.7),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        // make 10 more
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        Saving(name: "New House", amount: 1000, progress: 0.9),
        
    ]
    @State private var showAddSavings: Bool = false
    @State private var searchSavings: String = ""
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(Savings.filter {
                    searchSavings.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchSavings)
                }) { saving in
                    GroupBox(saving.name){
                        VStack(alignment: .leading){
                            
                            ProgressView(value: saving.progress, label: {  }, currentValueLabel: {                                 Text("\(saving.progress * 100, specifier: "%.0f") %")
                            })
                            .progressViewStyle(BarProgressStyle(height: 15.0))
                        }
                    }
                    .frame(maxHeight: 80)
                    .padding(.horizontal)
                    //                CircularProgressView(progress: saving.progress)
                    //                    .frame(width: 50, height: 50)
                    
                }
                Spacer()
            }
            //                .navigationTitle("Savings")
            .searchable(text: $searchSavings)
            .toolbar{
                ToolbarItem{
                    Button(action: {
                        showAddSavings = true
                    }, label: {
                        //                            Text("Add Saving")
                        Image(systemName: "plus")
                            .font(.title2)
                    })
                    .foregroundStyle(Color.primary)
                }
            }
            
        }
        .sheet(isPresented: $showAddSavings){
            NavigationStack{
                NewSavingView()
                    .navigationBarItems(trailing: Button("Done") {
                        showAddSavings = false
                    })
            }
            
            
        }
    }
}

#Preview {
    SavingsView()
}
