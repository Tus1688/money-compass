//
//  Persistence.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 06/12/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newTransaction = TransactionLog(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.amount = 500000
        newTransaction.timestamp = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        newTransaction.activityTitle = "Bank Account Deposit"
        newTransaction.activityDescription = "Initial deposit to your bank account"
        
        let newTransaction2 = TransactionLog(context: viewContext)
        newTransaction2.id = UUID()
        newTransaction2.amount = 500000
        newTransaction2.timestamp = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        newTransaction2.activityTitle = "Bank Account Deposit pt2"
        newTransaction2.activityDescription = "Initial deposit to your bank account pt2"
        
        let newBudget = SavingGoals(context: viewContext)
        newBudget.id = UUID()
        newBudget.amount = 100000
        newBudget.targetName = "Emergency Fund"
        newBudget.targetDescription = "Save up for emergency fund"
        
        let newBudget2 = SavingGoals(context: viewContext)
        newBudget2.id = UUID()
        newBudget2.amount = 100000
        newBudget2.targetName = "Stocks fund"
        newBudget2.targetDescription = "Save up to get rich"
        
        let transactionForBudget = TransactionLog(context: viewContext)
        transactionForBudget.id = UUID()
        transactionForBudget.amount = 50000
        transactionForBudget.timestamp = Date()
        transactionForBudget.activityTitle = "Bank Deposit for Emergency Fund"
        transactionForBudget.activityDescription = "Just saving up"
        transactionForBudget.budget_fk = newBudget
        
        let transactionForBudget2 = TransactionLog(context: viewContext)
        transactionForBudget2.id = UUID()
        transactionForBudget2.amount = 20000
        transactionForBudget2.timestamp = Date()
        transactionForBudget2.activityTitle = "number 2"
        transactionForBudget2.activityDescription = "Just saving up"
        transactionForBudget2.budget_fk = newBudget

        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MoneyCompass")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
