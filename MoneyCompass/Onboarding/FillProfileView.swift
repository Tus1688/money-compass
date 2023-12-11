//
//  FillProfileView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 09/12/23.
//

import SwiftUI
import CoreData

struct FillProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var onboardingCompleted: () -> Void
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var initialBalance = ""
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(
                        header: Text("Personal Information"),
                        footer: Text("This is how your name will be shown to your friends, bear in mind we do not collect nor track your name")
                    ) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }
                    Section(
                        header: Text("Financial Information"),
                        footer: Text("If you have debt you can fill it with minus")
                    ) {
                        TextField("Initial Balance", text: $initialBalance)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Fill Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        handleInsertData()
                    }
                }
            }
            .alert("Oopss...", isPresented: $isShowingAlert) {
                Button(role: .cancel) {
                    isShowingAlert = false
                } label: {
                    Text("Ok")
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    //  the initial balance could be minus (debt)
    func handleInsertData() {
        if firstName.isEmpty || lastName.isEmpty || initialBalance.isEmpty {
            alertMessage = "Please fill in all fields"
            isShowingAlert = true
            return
        }
        
        guard let balance = Double(initialBalance) else {
            alertMessage = "Please enter a valid initial balance"
            isShowingAlert = true
            return
        }
        
        let newTransaction = TransactionLog(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.activityTitle = "Initial balance"
        newTransaction.activityDescription = "Inserted on application onboarding"
        newTransaction.amount = balance
        newTransaction.timestamp = Date()
        
        do {
            try viewContext.save()
            let defaults = UserDefaults.standard
            defaults.set(firstName, forKey: "firstName")
            defaults.set(lastName, forKey: "lastName")
            defaults.set(balance, forKey: "balance")
            // force UserDefaults to save immediately
            defaults.synchronize()
            onboardingCompleted()
        } catch {
            print("Error saving managed object context: \(error.localizedDescription)")
        }
    }
}

#Preview {
    FillProfileView(onboardingCompleted: {
        print("done")
    }).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
