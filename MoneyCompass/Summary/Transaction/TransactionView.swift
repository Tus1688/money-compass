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
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(transactionLogs.filter {
                    searchTransaction.isEmpty ? true : $0.activityTitle!.localizedCaseInsensitiveContains(searchTransaction)
                }) { transaction in
                    GroupBox(transaction.activityTitle!){
                        HStack{
                            VStack(alignment: .leading) {
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
                    .padding(.horizontal)
                }
                Spacer()
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

#Preview {
    TransactionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
