//
//  NewGoalView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 11/12/23.
//
import SwiftUI
import CoreData
private struct GoalInput {
    var name: String = ""
    var description: String = ""
    var amount: Double = 0
}

struct NewSheetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var newGoal = GoalInput()
    @State private var newTransaction = TransactionInput()
    @State private var selectedForm: Int = 0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var body: some View {
        NavigationView {
            VStack{
                Picker(selection: $selectedForm, label: Text("Picker"), content: {
                    Text("Goal").tag(0)
                    Text("Transaction").tag(1)
                })
                .pickerStyle(.segmented)
                .padding(.horizontal)
                TabView(selection: $selectedForm){
                    Form {
                        Section(header: Text("Goal Name")) {
                            TextField("Required", text: $newGoal.name)
                        }
                        Section(header: Text("Goal Description")) {
                            TextField("Optional", text: $newGoal.description)
                        }
                        Section(header: Text("Goal Amount")) {
                            TextField("", value: $newGoal.amount, format: .number)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .tag(0)
                    Form {
                        Section(header: Text("Transaction Title")) {
                            TextField("Required", text: $newTransaction.title)
                        }
                        Section(header: Text("Transaction Description")) {
                            TextField("Optional", text: $newTransaction.description)
                        }
                        Section(header: Text("Category")) {
                            Picker("Category", selection: $newTransaction.category) {
                                Text("General")
                                Text("Food")
                                Text("Transportation")
                                Text("Entertainment")
                                Text("Education")
                                Text("Health")
                                Text("Others")
                            }
                        }
                        Section(header: Text("Amount")) {
                            TextField("Amount", value: $newTransaction.amount, format: .number)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .tag(1)
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage))
            })
            .navigationBarTitle("New \(selectedForm == 0 ? "Goal" : "Transaction")", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if selectedForm == 0 {
                        saveGoal()
                    } else {
                        HandleAddNewTransaction()
                    }
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
        transaction.id = UUID()
        transaction.activityDescription = newTransaction.description
        transaction.activityTitle = newTransaction.title
        transaction.amount = newTransaction.amount
        transaction.category = newTransaction.category
        transaction.timestamp = Date()
        do {
            try viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving new transaction: \(error)")
        }
    }
    private func saveGoal() {
        guard !newGoal.name.isEmpty else {
            showAlert = true
            alertTitle = "Name is empty"
            alertMessage = "Please enter a name for this goal"
            return
        }
        guard newGoal.amount > 0 else {
            showAlert = true
            alertTitle = "Amount is invalid"
            alertMessage = "Please enter a valid amount for this goal"
            return
        }
        let insertGoal = SavingGoals(context: viewContext)
        insertGoal.id = UUID()
        insertGoal.targetName = newGoal.name
        insertGoal.targetDescription = newGoal.description
        insertGoal.amount = newGoal.amount
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


#Preview {
    NewSheetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
