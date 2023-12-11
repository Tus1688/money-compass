//
//  SavingGoalsView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI

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
        .frame(width: .infinity, height: .infinity)
        .padding(3)
    }
}

struct Goals: Identifiable {
    var id : String {
        self.name
    }
    var name: String
    var price: Double
    var progress: Double
}

struct SavingGoalsView: View {
    @State var progress: Double = 1
    @State var goals: [Goals] = [
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
        Goals(name: "Sepatu", price: 2140000, progress: 0.5),
    ]
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack{
                    Text("Saving Goals")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.black)
                    })
                }) {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(goals, id: \.id) { goal in
                                VStack(){
                                    Text(goal.name)
                                        .frame(alignment: .leading)
                                    Text("Rp \(goal.price, specifier: "%.0f")")
                                        .font(.caption)
                                        .fontWeight(.light)
                                    
                                    CircularProgressView(progress: goal.progress)
                                }
                                .frame(width: 80, height: 120)
                                .padding(3)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    SavingGoalsView()
}
