//
//  NewSavingView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 16/12/23.
//

import SwiftUI

struct NewSavingView: View {
    @State private var newSaving: Saving = Saving(name: "", amount: 0.0, progress: 0.0)
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Saving Name")) {
                    TextField("Saving Name", text: $newSaving.name)
                }
                Section(header: Text("Amount")) {
                    TextField("Amount", value: $newSaving.amount, formatter: NumberFormatter())
                }
                Section(header: Text("Progress")) {
                    TextField("Progress", value: $newSaving.progress, formatter: NumberFormatter())
                }
            }
        }
    }
}

#Preview {
    NewSavingView()
}
