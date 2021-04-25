//
//  ProfileEditView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 11/03/2021.
//
import SwiftUI
import CoreData

//public extension Binding {
//
//    init(_ source: Binding<Value?>, _ defaultValue: Value) {
//            self.init(get: {
//                // ensure the source doesn't contain nil
//                if source.wrappedValue == nil {
//                    // try to assign--this may not initially work, since it seems
//                    // SwiftUI needs to wire things up inside Bindings before they
//                    // become properly 'writable'.
//                    source.wrappedValue = defaultValue
//                }
//                return source.wrappedValue ?? defaultValue
//            }, set: {
//                source.wrappedValue = $0
//            })
//        }
//}

let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.isLenient = true
    formatter.numberStyle = .none
        return formatter
    }()


struct ProfileEditView: View {
    
    //@Binding var profile: Profile
    var viewContext: NSManagedObjectContext
    var profile: Profile
    
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var age: Int64 = 0
    @State var examDuration: Float = 5
    
    var body: some View {
        NavigationView {
        Form {
            Section {
                TextField("Username", text: $username)
            }
            Section {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Age", value: $age, formatter: numberFormatter)
                    .keyboardType(.decimalPad)
            }
            Section {
                Stepper("\(examDuration) seconds", value: $examDuration, in: 1...60)
            }
        }
        
        .navigationBarItems(
                       leading: Button(action: self.onCancelTapped) { Text("Cancel")},
                       trailing: Button(action: self.onSaveTapped) { Text("Save")}
                   )
        }
        .navigationTitle("Edit profile")
    }
    
    private func onCancelTapped() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onSaveTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let profile = self.profile
        profile.username = self.username
        profile.firstName = self.firstName
        profile.lastName = self.lastName
        profile.age = self.age
        profile.examDuration = self.examDuration

        try? self.viewContext.save()
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

//struct ProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileEditView()
//    }
//}
