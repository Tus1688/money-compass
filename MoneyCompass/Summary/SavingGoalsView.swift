//
//  SavingGoalsView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData

struct SavingGoalsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    struct DisplayGoal {
        let name: String
        let current: Double
        let target: Double
    }
    @State private var data: [DisplayGoal] = []
    
    var body: some View {
        
        List {
            Section(header:
                        Text("Saving Goals")
                .font(.title2)
                .fontWeight(.bold)
            ) {
                if data.isEmpty {
                    Text("No Saving Goals Yet!")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(data, id: \.name) { goal in
                                let progress = goal.current / goal.target
                                VStack(){
                                    Text(goal.name)
                                        .frame(alignment: .leading)
                                    Text("Rp \(goal.target, specifier: "%.0f")")
                                        .font(.caption)
                                        .fontWeight(.light)
                                    CircularProgressView(progress: progress)
                                }
                                .frame(width: 80, height: 120)
                                .padding(3)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onAppear(){
            fetchSavingGoalsTotalAmount()
            
        }
    }
    
    private func fetchSavingGoalsTotalAmount() {
        guard let savingGoals = fetchAllSavingGoals() else { return }
        
        var displayGoals: [DisplayGoal] = []
        
        for savingGoal in savingGoals {
            if let transactionLogs = savingGoal.budgetlog_fk?.allObjects as? [TransactionLog] {
                let totalAmount = transactionLogs.reduce(0.0) { $0 + ($1.amount ) }
                let displayGoal = DisplayGoal(name: savingGoal.targetName ?? "",
                                              current: totalAmount,
                                              target: savingGoal.amount)
                displayGoals.append(displayGoal)
            }
        }
        
        self.data = displayGoals
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
    SavingGoalsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
