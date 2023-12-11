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
struct RecentTransactions: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionLog.timestamp, ascending: false)],
        animation: .default
    )
    private var transactionLogs: FetchedResults<TransactionLog>
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            TabView{
                List {
                    Section(header: HStack{
                        Text("Recent Transaction")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2)
                                .foregroundColor(.black)
                        })
                    }) {
                        
                        ForEach(transactionLogs) { transaction in
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(transaction.activityTitle!)
                                        .font(.subheadline)
                                    Text(transaction.activityDescription!)
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
                            .listRowSeparator(.hidden)
                        }
                        
                    }
                }
                .listStyle(.plain)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
    }
}



#Preview {
    RecentTransactions().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
