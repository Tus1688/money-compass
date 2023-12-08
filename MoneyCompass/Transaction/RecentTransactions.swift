//
//  RecentTransactions.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 08/12/23.
//

import SwiftUI
import CoreData

struct RecentTransactions: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionLog.timestamp, ascending: true)],
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
            List {
                ForEach(transactionLogs) { transaction in
                    VStack(alignment: .leading) {
                        Text(transaction.activityTitle!)
                        Text(currencyFormatter.string(from: transaction.amount as NSNumber)!)
                    }
                }
            }
        }
    }
}

#Preview {
    RecentTransactions().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
