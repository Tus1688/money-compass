//
//  ProfileView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .listRowBackground(Color(.clear))
            
            Section(header: Text("Personal Information")) {
                HStack {
                    if !firstName.isEmpty {
                        Text("First Name")
                    }
                    TextField("First Name", text: $firstName)
                        .multilineTextAlignment(firstName.isEmpty ? .leading : .trailing)
                }
                HStack {
                    if !lastName.isEmpty {
                        Text("Last Name")
                    }
                    TextField("Last Name", text: $lastName)
                        .multilineTextAlignment(lastName.isEmpty ? .leading : .trailing)
                }
            }
        }
    }
}
