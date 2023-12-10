//
//  OnBoardingView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 09/12/23.
//

import SwiftUI

struct OnBoardingItem: Identifiable {
    var id = UUID()
    var title: String
    var headline: String
    var image: String
}

struct OnBoardingView: View {
    var onboardingCompleted: () -> Void
    
    // TODO: fill the onboardingItem with appropriate content
    let items: [OnBoardingItem] = [
        OnBoardingItem(title: "Freedom", headline: "Achieve your financial goals", image: "onboarding1"),
        OnBoardingItem(title: "Rich", headline: "Analyze and Improve your spendings", image: "onboarding2"),
        OnBoardingItem(title: "Secure", headline: "Your data is safe with us", image: "onboarding3")
    ]
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(self.items, id: \.id) { item in
                    VStack {
                        OnBoardingCardView(item: item)
                        
                        NavigationLink(destination: FillProfileView(onboardingCompleted: onboardingCompleted)) {
                            HStack(spacing: 8) {
                                Text("Start")
                                
                                Image(systemName: "arrow.right.circle")
                                    .imageScale(.large)
                                
                            }
                        }
                        .padding()
                    }
                    .tag(item.id)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
        }
    }
}

#Preview {
    OnBoardingView(onboardingCompleted: {
        print("done")
    }).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
