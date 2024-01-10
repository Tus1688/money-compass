//
//  DailyExpensesView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 16/12/23.
//

import SwiftUI
import Charts
import CoreData

struct DailyExpensesView: View {
    struct ProfitByCategory {
        let profit: Double
        let productCategory: String
        let day: String
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var data: [ProfitByCategory] = []
    
    
    var body: some View {
        Chart(data, id: \.day) {
            BarMark(
                x: .value("Category", $0.day),
                y: .value("Profit", $0.profit)
            )
            .foregroundStyle(by: .value("Product Category", $0.productCategory))
        }
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        let request: NSFetchRequest<TransactionLog> = TransactionLog.fetchRequest()
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        //  7 days ago
        let dateFrom = calendar.date(byAdding: .day, value: -7, to: Date())
        let dateTo = Date()
        
        let fromPredicate = NSPredicate(format: "timestamp >= %@", dateFrom! as NSDate)
        let toPredicate = NSPredicate(format: "timestamp <= %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        
        do {
            let fetchedData = try viewContext.fetch(request)
            
            data = processData(fetchedData)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func processData(_ fetchedData: [TransactionLog]) -> [ProfitByCategory] {
        var profitByCategory: [String: Double] = [:]
        var profitByDate: [Date: Double] = [:] // Dictionary to hold profit by date
        
        let calendar = Calendar.current
        
        for transaction in fetchedData {
            guard let timestamp = transaction.timestamp else { continue }
            
            let category = "General"
            
            if let existingProfit = profitByCategory[category] {
                profitByCategory[category] = existingProfit + transaction.amount
            } else {
                profitByCategory[category] = transaction.amount
            }
            
            let dateComponents = calendar.dateComponents([.day, .month, .year], from: timestamp)
            if let date = calendar.date(from: dateComponents) {
                if let existingProfit = profitByDate[date] {
                    profitByDate[date] = existingProfit + transaction.amount
                } else {
                    profitByDate[date] = transaction.amount
                }
            }
        }
        
        var processedData: [ProfitByCategory] = []
            for (date, profit) in profitByDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: date)
                
                processedData.append(ProfitByCategory(profit: profit, productCategory: "General", day: dateString))
            }
            
            processedData.sort { (first: ProfitByCategory, second: ProfitByCategory) -> Bool in
                return first.day < second.day
            }
            
            return processedData
    }

}

#Preview {
    DailyExpensesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
