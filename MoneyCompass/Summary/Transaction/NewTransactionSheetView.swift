//
//  NewTransactionSheetView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 11/01/24.
//

import SwiftUI
import CoreData

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
    @Binding var fetchTrigger: Bool
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Transaction Title")) {
                    TextField("Required", text: $newTransaction.title)
                }
                Section(header: Text("Transaction Description")) {
                    TextField("Optional", text: $newTransaction.description)
                }
                Section(header: Text("Category")) {
                    Picker("Category", selection: $newTransaction.category) {
                        Text("General").tag("General")
                        Text("Food").tag("Food")
                        Text("Transportation").tag("Transportation")
                        Text("Entertainment").tag("Entrainment")
                        Text("Education").tag("Education")
                        Text("Health").tag("Health")
                        Text("Others").tag("Others")
                    }
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
                    fetchTrigger.toggle()
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
        let goal = fetchGoal()
        transaction.budget_fk = goal
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
    
    private func fetchGoal() -> SavingGoals {
        let request: NSFetchRequest<SavingGoals> = SavingGoals.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
        do {
            let results = try viewContext.fetch(request)
            return results[0]
        } catch {
            print("Error fetching goal: \(error)")
        }
        return SavingGoals()
    }
}

