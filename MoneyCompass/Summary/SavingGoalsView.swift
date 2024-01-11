//
//  SavingGoalsView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData


struct DisplayGoal: Identifiable {
    let id: UUID
    let name: String
    let current: Double
    let target: Double
}

struct SavingGoalsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var selectedGoal: DisplayGoal? = nil
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
                            ForEach(data, id: \.id) { goal in
                                let progress = goal.current / goal.target
                                VStack{
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
                                .onTapGesture {
                                    selectedGoal = goal
                                }
                            }
                            .sheet(item: $selectedGoal) { goal in
                                NewTransactionSheetView(
                                    goal: goal
                                )
                            }
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
        }

        .listStyle(.plain)
        .onAppear{
            fetchSavingGoalsTotalAmount()
            
        }
    }
    
    private func fetchSavingGoalsTotalAmount() {
        guard let savingGoals = fetchAllSavingGoals() else { return }
        
        var displayGoals: [DisplayGoal] = []
        
        for savingGoal in savingGoals {
            if let transactionLogs = savingGoal.budgetlog_fk?.allObjects as? [TransactionLog] {
                let totalAmount = transactionLogs.reduce(0.0) { $0 + ($1.amount ) }
                let displayGoal = DisplayGoal(id: savingGoal.id!, name: savingGoal.targetName ?? "",
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
