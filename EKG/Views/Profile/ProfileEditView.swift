//
//  ProfileEditView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 11/03/2021.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.showingSheet) var showingSheet
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var examDuration = 5
    
    private var invalidInput: Bool {
        
        username.isEmpty || firstName.isEmpty || lastName.isEmpty || username.count < 3 || Int64(age) == nil
    }
    
    private var usernameIsTaken: Bool {
        if !username.isEmpty {
            let fetchRequest = FetchRequest<Profile> (entity: Profile.entity(), sortDescriptors: [], predicate: NSPredicate(format: "username == %@", $username as! CVarArg), animation: .default)
            
            let test = fetchRequest.wrappedValue

            if test.count == 0 {
                return false
            }
            else {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $username)
                    if usernameIsTaken {
                        Text("Username is already taken")
                            .foregroundColor(.red)
                    }
                }
                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Age", text: $age)
                        .keyboardType(.decimalPad)
                }
                Section {
                    Stepper("\(examDuration) seconds", value: $examDuration, in: 1...60)
                }
                Section {
                    Button("Update") {
                        withAnimation {
                            
                            let fetchRequest = FetchRequest<Profile> (entity: Profile.entity(), sortDescriptors: [], predicate: NSPredicate(format: "username == %@", $username as! CVarArg), animation: .default)
                            let profile = fetchRequest.wrappedValue[0]
                            profile.username = self.username
                            profile.firstName = self.firstName
                            profile.lastName = self.lastName
                            // TODO verify if numbers
                            profile.age = Int64(self.age) ?? 0
                            profile.examDuration = Float(self.examDuration)
                            
                            try? self.viewContext.save()
                            
                            self.showingSheet?.wrappedValue = false
                        }
                    }
                }.disabled(invalidInput)
            }.navigationBarTitle("New User")
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}
