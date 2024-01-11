//
//  CircularProgressView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 09/01/24.
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
            if progress == 1 {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
            } else {
                Text("\(progress * 100, specifier: "%.0f")%")
                    .fontWeight(.semibold)
            }
        }
        .padding(3)
    }
}
