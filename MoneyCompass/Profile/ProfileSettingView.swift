//
//  ProfileSettingView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 12/12/23.
//

import SwiftUI

struct ProfileSettingView: View {
    @State var isEditing = false
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        NavigationStack {
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
                            .disabled(!isEditing)
                            .foregroundStyle(isEditing ? .accent : .primary)
                    }
                    HStack {
                        if !lastName.isEmpty {
                            Text("Last Name")
                        }
                        TextField("Last Name", text: $lastName)
                            .multilineTextAlignment(lastName.isEmpty ? .leading : .trailing)
                            .disabled(!isEditing)
                            .foregroundStyle(isEditing ? .accent : .primary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                        
                        let defaults = UserDefaults.standard
                        defaults.set(firstName, forKey: "firstName")
                        defaults.set(lastName, forKey: "lastName")
                        
                        defaults.synchronize()
                    }) {
                        if isEditing {
                            Text("Done").bold()
                        } else {
                            Text("Edit")
                        }
                    }
                }
            }
            .onAppear {
                // because userdefaults state only change on the first appear
                firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
                lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileSettingView()
}
