//
//  NewGoalView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 11/12/23.
//
import SwiftUI
import CoreData

struct NewGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var targetName: String = ""
    @State private var targetDescription: String = ""
    @State private var amount: Double = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Target Name")) {
                    TextField("Target Name", text: $targetName)
                }
                Section(header: Text("Target Description")) {
                    TextField("Target Description", text: $targetDescription)
                }
                Section(header: Text("Amount")) {
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
                                trailing: Button("Save") {
                saveGoal()
            })
        }
    }
    
    private func saveGoal() {
        let newGoal = SavingGoals(context: viewContext)
        newGoal.id = UUID()
        newGoal.targetName = targetName
        newGoal.targetDescription = targetDescription
        newGoal.amount = amount
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
