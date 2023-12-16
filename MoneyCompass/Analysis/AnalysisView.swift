//
//  AnalysisView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 15/12/23.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        NavigationStack{
            VStack{
                HStack {
                    Text("This Month")
                        .font(.largeTitle.bold())
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.primary)
                }
                .padding(.top, 36)
                GroupBox("Daily Expenses"
                ) {
                    DailyExpensesView()
                        .frame(maxHeight: 150)
                }
                HStack{
                    GroupBox("Saving Goal"
                    ) {
                        CircularProgressView(progress: 0.3)
                        
                    }
                    GroupBox("Budget & Spending"
                    ) {
                        CircularProgressView(progress: 0.5)
                        
                    }
                }
                GroupBox("Top Expenses"
                ) {
                   TopExpensesView()
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    AnalysisView()
}
