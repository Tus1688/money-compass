//
//  NewTransactionSheetView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 11/01/24.
//

import SwiftUI
struct TransactionInput {
    var title: String = ""
    var description: String = ""
    var amount: Double = 0
    var category: String = ""
}
struct NewTransactionSheetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    var goal : DisplayGoal
    @State var newTransaction = TransactionInput()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Transaction Title")) {
                    TextField("Required", text: $newTransaction.title)
                }
                Section(header: Text("Transaction Description")) {
                    TextField("Optional", text: $newTransaction.description)
                }
                Section(header: Text("Amount")) {
                    TextField("Amount", value: $newTransaction.amount, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("\(goal.id)", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    HandleAddNewTransaction()
                }
            )
        }
    }
    private func HandleAddNewTransaction() {
        guard !newTransaction.title.isEmpty else {
            showAlert = true
            alertTitle = "Title is empty"
            alertMessage = "Please enter a title for this transaction"
            return
        }
        let transaction = TransactionLog(context: viewContext)
//        TODO: INSERT SAVING GOALS FOREIGN KEY HERE
        transaction.id = UUID()
        transaction.activityDescription = newTransaction.description
        transaction.activityTitle = newTransaction.title
        transaction.amount = newTransaction.amount
        transaction.timestamp = Date()
        do {
            try viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving new transaction: \(error)")
        }
    }
}

