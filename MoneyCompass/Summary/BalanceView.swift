//
//  BalanceView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData
import AnimateNumberText

struct BalanceView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor<TransactionLog>(\.timestamp)],
        animation: .default)
    private var transactionLogs: FetchedResults<TransactionLog>
    @State private var ShowBalance: Bool = false
    @State private var TextColor: Color = .black
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }
    @State private var balance: Double = 0
    
    
    
    var body: some View {
        ZStack{
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    HStack{
                        Text("Balance")
                            .font(.title3)
                            .foregroundColor(.black)
                        Image(systemName: ShowBalance ? "eye" : "eye.slash")
                            .onTapGesture {
                                ShowBalance.toggle()
                            }
                            .animation(Animation.easeOut, value: ShowBalance)
                    }
                    if (ShowBalance){
                        AnimateNumberText(value: $balance,
                                          textColor: $TextColor,
                                          numberFormatter:                     numberFormatter
                        )
                    } else {
                        Text("********")
                            .font(.largeTitle)
                    }
                }
                Spacer()
                Image(systemName: "tray.full")
                    .font(.title)
                    .frame(width: 40, height: 40)
                    .padding(2)
                    .background(Color.white)
                    .cornerRadius(3)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .padding()
        .onAppear(perform: {
            var totalAmount: Double = 0
            for transaction in transactionLogs {
                totalAmount += transaction.amount
            }
            balance = totalAmount
            if (balance < 0) {
                TextColor = .red
            } else {
                TextColor = .black
            }
        })
    }
    
}
