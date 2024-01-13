//
//  ProfileView.swift
//  MoneyCompass
//
//  Created by MacBook Pro on 10/12/23.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
                        resetEntity()
                        resetUserDefaults()
                    })
                }
            }
        }
    }
    private func resetEntity() {
        let entityNames = ["SavingGoals", "TransactionLog"]
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func resetUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
    }
}

#Preview {
    ProfileView()
}
