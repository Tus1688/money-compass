//
//  TransactionView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 15/12/23.
//

import SwiftUI
import CoreData
struct TransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionLog.timestamp, ascending: false)],
        animation: .default
    )
    private var transactionLogs: FetchedResults<TransactionLog>
    @State var isTransactionSheetPresented = false
    @State private var searchTransaction: String = ""
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(transactionLogs.filter {
                    searchTransaction.isEmpty ? true : $0.activityTitle!.localizedCaseInsensitiveContains(searchTransaction)
                }) { transaction in
                    
                    HStack{
                        VStack(alignment: .leading) {
                            Text(transaction.activityTitle ?? "No Title")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text(transaction.activityDescription ?? "No Description")
                                .font(.caption)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text(currencyFormatter.string(from: transaction.amount as NSNumber)!)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.footnote)
                            Text(transaction.timestamp!.formatted())
                                .font(.caption)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        viewContext.delete(transactionLogs[index])
                    }
                    do {
                        try viewContext.save()
                        fetchTrigger.toggle()
                    } catch {
                        print(error.localizedDescription)
                    }
                })
            }
            .navigationTitle("All Transactions")
            .searchable(text: $searchTransaction)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
        }
    }
}
