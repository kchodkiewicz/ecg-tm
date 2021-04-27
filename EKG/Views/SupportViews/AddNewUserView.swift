//
//  AddNewUserView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import SwiftUI

struct AddNewUserView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //@Environment(\.showingSheet) var showingSheet
    @Environment(\.presentationMode) var presentationMode
    //@Environment(\.editMode) var editMode
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = Date()
    @State private var examDuration = 5
    @State private var profileColor = ProfileColor.crimson
    
    private var invalidInput: Bool {
        
        username.isEmpty || firstName.isEmpty || lastName.isEmpty || username.count < 3 || Int64(examDuration) <= 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    
                    UserIcon(profileColor: self.$profileColor)
                
                    TextField("Username", text: $username)
                    
                    TextField("First Name", text: $firstName)
                    
                    TextField("Last Name", text: $lastName)
                }
                Section {
                    
                    DatePicker("Birthdate", selection: $age, in: Formatters.closeBirthDateRange, displayedComponents: .date)
                        .multilineTextAlignment(.trailing)
                        .datePickerStyle(WheelDatePickerStyle())
                
                    Stepper("\(examDuration) seconds", value: $examDuration, in: 1...360)
                }
//                Section {
//                    Button("Add") {
//                        withAnimation {
//                            
//                            let profile = Profile(context: self.viewContext)
//                            profile.id = UUID()
//                            profile.username = self.username
//                            profile.firstName = self.firstName
//                            profile.lastName = self.lastName
//                            profile.age = self.age 
//                            profile.examDuration = Float(self.examDuration)
//                            profile.profileColor = self.profileColor.rawValue
//                            
//                            try? self.viewContext.save()
//                            
//                            self.showingSheet?.wrappedValue = false
//                        }
//                    }
//                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    withAnimation(.spring()) {
                        onSaveTapped()
                    }
                }) {
                    Text("Add")
                }
                .disabled(invalidInput)
                .padding(.bottom)
                .padding(.leading)
            )
            
            .navigationBarTitle("New User")
        }
    }
    
    private func onSaveTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let profile = Profile(context: self.viewContext)
        profile.id = UUID()
        profile.username = self.username
        profile.firstName = self.firstName
        profile.lastName = self.lastName
        // TODO verify if numbers
        profile.age = self.age
        profile.examDuration = Float(self.examDuration)
        profile.profileColor = self.profileColor.rawValue
        
        try? self.viewContext.save()
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewUserView()
    }
}
