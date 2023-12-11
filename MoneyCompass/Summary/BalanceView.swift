//
//  BalanceView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import AnimateNumberText

struct BalanceView: View {
    @State private var ShowBalance: Bool = true
    @State private var TextColor: Color = .black
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }
    @State private var balance: Double
    
    init() {
        // Convert the string from UserDefaults to a double
        if let storedBalanceString = UserDefaults.standard.string(forKey: "balance"),
           let storedBalance = Double(storedBalanceString) {
            _balance = State(initialValue: storedBalance)
        } else {
            _balance = State(initialValue: 0) // Default value if conversion fails
        }
    }
    
    var body: some View {
        ZStack{
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    HStack{
                        Text("Balance")
                            .font(.title3)
                            .foregroundColor(.black)
                        Image(systemName: ShowBalance ? "eye.slash" : "eye")
                            .onTapGesture {
                                ShowBalance.toggle()
                            }
                            .animation(Animation.easeOut, value: ShowBalance)
                    }
                    AnimateNumberText(value: $balance,
                                      textColor: $TextColor,
                                      numberFormatter:                     numberFormatter
                    )
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
    }
}

#Preview {
    BalanceView()
}
