//
//  ProfileEditView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 11/03/2021.
//
import SwiftUI
import CoreData
import CoreBluetooth

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
    formatter.numberStyle = .none
    formatter.minimum = 0
    return formatter
}()


struct ProfileEditView: View {
    
    //@Binding var profile: Profile
    var viewContext: NSManagedObjectContext
    var profile: Profile
    
    @ObservedObject var bleConnection = BLEConnection()
    
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var activeSession: ActiveSession
    
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var age: String = ""
    @State var examDuration: Int = 5
    
    var body: some View {
        
        Form {
            Section {
                HStack {
                    Text("Username")

                    Spacer()
                    
                    TextField("Username", text: $username)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor((.active == self.editMode?.wrappedValue) ? Color.blue : Color.primary)
                        .multilineTextAlignment(.trailing)
                }
            }
            Section {
                HStack {
                    Text("First Name")

                    Spacer()
                    TextField("First Name", text: $firstName)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor((.active == self.editMode?.wrappedValue) ? Color.blue : Color.primary)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Last Name")

                    Spacer()
                    TextField("Last Name", text: $lastName)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor((.active == self.editMode?.wrappedValue) ? Color.blue : Color.primary)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Age")

                    Spacer()
                    TextField("Age", text: $age)
                        .keyboardType(.decimalPad)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor((.active == self.editMode?.wrappedValue) ? Color.blue : Color.primary)
                        .multilineTextAlignment(.trailing)
                }
            }
            Section {
                if self.editMode?.wrappedValue == .inactive {
                    HStack {
                        Text("Exam Duration:")
                        Spacer()
                        Text("\(Int(self.profile.examDuration))")
                    }
                } else {
                    
                    Stepper("\(examDuration) seconds", value: $examDuration, in: 1...60)
                    
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor((.active == self.editMode?.wrappedValue) ? Color.blue : Color.primary)
                }
            }
            if self.editMode?.wrappedValue == .inactive {
                Section {
                    
                    NavigationLink(destination: BTView(bleConnection: bleConnection)) {
                        Text("Bluetooth Device")
                        Spacer()
                        Text(bleConnection.peripheral?.name ?? "None")
                    }
                }
                Section {
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.activeSession.profile = nil
                        }
                    } label: {
                        Text("Switch User")
                    }
                    
                    
                }
            }
        }
        
        .navigationBarItems(
            leading: Button(action: {
                withAnimation(.spring()) {
                    self.editMode?.wrappedValue = .active == self.editMode?.wrappedValue ? .inactive : .active
                }
            }) {
                Text(.active == self.editMode?.wrappedValue ? "Cancel" : "")
            }
            .padding(.bottom)
            .padding(.trailing),
            trailing: Button(action: {
                withAnimation(.spring()) {
                    self.editMode?.wrappedValue = .active == self.editMode?.wrappedValue ? .inactive : .active
                    onSaveTapped()
                }
            }) {
                Text(.active == self.editMode?.wrappedValue ? "Done" : "Edit")
            }
            .padding(.bottom)
            .padding(.leading)
        )
        
        .navigationBarTitle(.inactive == self.editMode?.wrappedValue ? "\(self.firstName) \(self.lastName)" : "Edit your profile")
        
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
        profile.age = Int64(self.age) ?? 11
        profile.examDuration = Float(self.examDuration)
        
        try? self.viewContext.save()
        
        //self.presentationMode.wrappedValue.dismiss()
    }
}

//struct ProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileEditView()
//    }
//}
