//
//  DailyExpensesView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 16/12/23.
//

import SwiftUI
import Charts
struct DailyExpensesView: View {
    struct ProfitByCategory {
        let department: String
        let profit: Double
        let productCategory: String
        let day: String
    }


    let data: [ProfitByCategory] = [
        ProfitByCategory(department: "Food", profit: 100, productCategory: "Food", day: "Monday"),
        ProfitByCategory(department: "Food", profit: 200, productCategory: "Food", day: "Tuesday"),
        ProfitByCategory(department: "Food", profit: 300, productCategory: "Food", day: "Wednesday"),
        ProfitByCategory(department: "Food", profit: 400, productCategory: "Food", day: "Thursday"),
        ProfitByCategory(department: "Food", profit: 500, productCategory: "Food", day: "Friday"),
        ProfitByCategory(department: "Food", profit: 600, productCategory: "Food", day: "Saturday"),
        ProfitByCategory(department: "Food", profit: 700, productCategory: "Food", day: "Sunday"),
        ProfitByCategory(department: "Transportation", profit: 100, productCategory: "Transportation", day: "Monday"),
        ProfitByCategory(department: "Transportation", profit: 200, productCategory: "Transportation", day: "Tuesday"),
        ProfitByCategory(department: "Transportation", profit: 300, productCategory: "Transportation", day: "Wednesday"),
        ProfitByCategory(department: "Transportation", profit: 400, productCategory: "Transportation", day: "Thursday"),
        ProfitByCategory(department: "Transportation", profit: 500, productCategory: "Transportation", day: "Friday"),
        ProfitByCategory(department: "Transportation", profit: 600, productCategory: "Transportation", day: "Saturday"),
        ProfitByCategory(department: "Transportation", profit: 700, productCategory: "Transportation", day: "Sunday"),
    ]


    var body: some View {
        Chart(data, id: \.day) {
            BarMark(
                x: .value("Category", $0.day),
                y: .value("Profit", $0.profit)
            )
            .foregroundStyle(by: .value("Product Category", $0.productCategory))
        }
    }
}

#Preview {
    DailyExpensesView()
}
