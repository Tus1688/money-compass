//
//  SavingGoalsView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData
struct CircularProgressView: View {
    let progress: Double
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .stroke(
                        Color.gray.opacity(0.3),
                        lineWidth: 6
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.accentColor,
                        style: StrokeStyle(
                            lineWidth: 6,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                
            }
            Text("\(progress * 100, specifier: "%.0f")%")
                .fontWeight(.semibold)
        }
        .padding(3)
    }
}

struct SavingGoalsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor<SavingGoals>(\.targetName)],
        animation: .default)
    private var goals: FetchedResults<SavingGoals>
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor<TransactionLog>(\.timestamp)],
        animation: .default)
    private var transactionLogs: FetchedResults<TransactionLog>
    var body: some View {
        NavigationStack {
            List {
                Section(header:
                            Text("Saving Goals")
                    .font(.title2)
                    .fontWeight(.bold)
                ) {
                    if (goals.count == 0) {
                        Text("No Saving Goals Yet!")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(goals) { goal in
                                    VStack(){
                                        Text(goal.targetName!)
                                            .frame(alignment: .leading)
                                        Text("Rp \(goal.amount, specifier: "%.0f")")
                                            .font(.caption)
                                            .fontWeight(.light)
                                        //                                        Text("\(goal., specifier: "%.0f")")
                                        
                                        CircularProgressView(progress: goal.progress)
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
        }
        .onAppear(){
            // join transaction log and saving goals, check if savinggoals's budgetlog_fk is in transaction log's budget_fk and update progress
            for goal in goals {
                var total = 0.0
                for log in transactionLogs {
                    if (log.budget_fk == goal.budgetlog_fk) {
                        total += log.amount + 1000
                    }
                }
                goal.progress = total / goal.amount
            }
        }
    }
}

#Preview {
    SavingGoalsView()
}
