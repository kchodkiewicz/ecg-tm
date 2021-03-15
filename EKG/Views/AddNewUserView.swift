//
//  AddNewUserView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import SwiftUI

struct AddNewUserView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.showingSheet) var showingSheet
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var examDuration = ""
    
    private var validateInput: Bool {
        
        username.isEmpty || firstName.isEmpty || lastName.isEmpty || username.count < 3 || Int64(age) == nil || Int64(examDuration) == nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $username)
                }
                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Age", text: $age)
                        .keyboardType(.decimalPad)
                }
                Section {
                    TextField("Exam Duration", text: $examDuration)
                        .keyboardType(.decimalPad)
                }
                Section {
                    Button("Add") {
                        withAnimation {
                            
                            let profile = Profile(context: self.viewContext)
                            profile.id = UUID()
                            profile.username = self.username
                            profile.firstName = self.firstName
                            profile.lastName = self.lastName
                            // TODO verify if numbers
                            profile.age = Int64(self.age) ?? 0
                            profile.examDuration = Float(self.examDuration) ?? 5
                            
                            try? self.viewContext.save()
                            
                            self.showingSheet?.wrappedValue = false
                        }
                    }
                }.disabled(validateInput)
            }.navigationBarTitle("New User")
        }
    }
}

struct AddNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewUserView()
    }
}
