//
//  RecentTransactions.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 08/12/23.
//

import SwiftUI
import CoreData
extension Array {
    func chunked(by distance: Int) -> [[Element]] {
        let indicesSequence = stride(from: startIndex, to: endIndex, by: distance)
        let array: [[Element]] = indicesSequence.map {
            let newIndex = $0.advanced(by: distance) > endIndex ? endIndex : $0.advanced(by: distance)
            
            return Array(self[$0 ..< newIndex])
        }
        return array
    }
    
}
let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()

struct RecentTransactions: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionLog.timestamp, ascending: false)],
        animation: .default
    )
    private var transactionLogs: FetchedResults<TransactionLog>
    @State var isTransactionSheetPresented = false
    var body: some View {
        NavigationStack {
            TabView{
                List {
                    Section(header: HStack{
                        Text("Recent Transaction")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        Button(action: {
                            isTransactionSheetPresented.toggle()
                        }, label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2)
                        })
                    }) {
                        if (transactionLogs.count == 0) {
                            
                            Text("No Saving Goals Yet!")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(transactionLogs) { transaction in
                                HStack{
                                    VStack(alignment: .leading) {
                                        Text(transaction.activityTitle ?? "No Title")
                                            .font(.subheadline)
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
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .sheet(isPresented: $isTransactionSheetPresented){
                TransactionView()
            }
        }
    }
}



#Preview {
    RecentTransactions().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
