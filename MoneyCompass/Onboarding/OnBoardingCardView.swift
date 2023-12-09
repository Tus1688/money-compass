//
//  OnBoardingCardView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 09/12/23.
//

import SwiftUI

struct OnBoardingCardView: View {
    var item: OnBoardingItem
    
    @State private var animate = false
    
    var body: some View {
        ZStack{
            VStack(spacing: 24) {
                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(animate ? 1.0 : 0.6)
                
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text(item.headline)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: 480)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animate = true
            }
        }
    }
}

#Preview {
    OnBoardingCardView(item: OnBoardingItem(title: "title", headline: "headline", image: "image"))
}
