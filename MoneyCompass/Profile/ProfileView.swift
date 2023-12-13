//
//  ProfileView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Spacer()
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .listRowBackground(Color(.clear))
                
                Section {
                    NavigationLink(destination: ProfileSettingView()) {
                        Text("Personal Details")
                    }
                    Button("Reset Data", action: {
                        // TODO: reset whole data
                    })
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
