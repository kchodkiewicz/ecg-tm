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
    @State private var age = Date()
    @State private var examDuration = 5
    @State private var profileColor = ProfileColor.crimson
    
    private var invalidInput: Bool {
        
        username.isEmpty || firstName.isEmpty || lastName.isEmpty || username.count < 3 || Int64(examDuration) == 0
    }
    
    var closedRange: ClosedRange<Date> {
        let lower = Calendar.current.date(byAdding: .year, value: -150, to: Date())!
        let upper = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        
        return lower...upper
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    
                    UserIcon(profileColor: self.$profileColor)
                
                    TextField("Username", text: $username)
                }
                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker("Birthdate", selection: $age, in: closedRange, displayedComponents: .date)
                }
                Section {
                    Stepper("\(examDuration) seconds", value: $examDuration, in: 1...60)
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
                            profile.age = self.age 
                            profile.examDuration = Float(self.examDuration)
                            profile.profileColor = self.profileColor.ColorValue
                            
                            try? self.viewContext.save()
                            
                            self.showingSheet?.wrappedValue = false
                        }
                    }
                }.disabled(invalidInput)
                
            }
            .navigationBarTitle("New User")
        }
    }
}

struct AddNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewUserView()
    }
}
