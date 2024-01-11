//
//  AnalysisView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 15/12/23.
//

import SwiftUI
import CoreData

struct AnalysisView: View {
    // all target - all amount
    @State private var SavingGoal = 0.0
    @State private var BudgetAndSpending = 0.0
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        Section(header: Text("Daily Expenses")) {
            DailyExpensesView()
                .padding(.top,8)
                .frame(height: 250)
        }
        .headerProminence(.increased)
        Section(header: Text("Saving Goals")) {
            CircularProgressView(progress: SavingGoal)
                .frame(width: .infinity, height: 150, alignment: .center)
        }
        .headerProminence(.increased)
        .onAppear {
            fetchSavingGoalsTotalAmount()
        }
    }
    
    private func fetchSavingGoalsTotalAmount() {
        guard let savingGoals = fetchAllSavingGoals() else { return }
        
        var currentSavingGoalTotal = 0.0
        var targetSavingGoalTotal = 0.0
        
        for savingGoal in savingGoals {
            // Access associated TransactionLogs through the inverse relationship
            if let transactionLogs = savingGoal.budgetlog_fk?.allObjects as? [TransactionLog] {
                // Calculate the total amount for the current SavingGoal
                let totalAmount = transactionLogs.reduce(0.0) { $0 + $1.amount }
                currentSavingGoalTotal += totalAmount
                // Accumulate the target amount
                targetSavingGoalTotal += savingGoal.amount
            }
        }
        
        // Calculate the ratio if targetSavingGoalTotal is not zero to avoid division by zero
        if targetSavingGoalTotal != 0.0 {
            SavingGoal = currentSavingGoalTotal / targetSavingGoalTotal
        } else {
            SavingGoal = 0.0
        }
    }
    
    
    private func fetchAllSavingGoals() -> [SavingGoals]? {
        // Assuming you have access to your managed object context
        let fetchRequest = NSFetchRequest<SavingGoals>(entityName: "SavingGoals")
        do {
            let savingGoals = try viewContext.fetch(fetchRequest)
            return savingGoals
        } catch {
            print("Error fetching SavingGoals: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    AnalysisView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
