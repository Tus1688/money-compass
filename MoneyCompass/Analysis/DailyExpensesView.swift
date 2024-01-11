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
        var res: [ProfitByCategory] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for transaction in fetchedData {
            let profit = transaction.amount
            let productCategory = transaction.category ?? "General"
            let day = dateFormatter.string(from: transaction.timestamp!)
            res.append(ProfitByCategory(profit: profit, productCategory: productCategory, day: day))
        }
        
        // sort by day
        res.sort(by: { $0.day < $1.day })
        return res
    }
}

#Preview {
    DailyExpensesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
