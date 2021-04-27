//
//  ProfileEditView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 11/03/2021.
//
import SwiftUI
import CoreData
import CoreBluetooth


public func getAge(birthdate: Date) -> String {
    
    let current = Calendar.current
    
    let years = current.dateComponents(
      [.year],
      from: birthdate,
      to: Date()
    )
    
    return String(years.year!)
}

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
    @State var age: Date = Date()
    @State var examDuration: Int = 5
    @State var profileColor: ProfileColor = ProfileColor.crimson
    
    @State var showingAge: Bool = true
    
    var body: some View {
        
        Form {
            
            Section {
                if .inactive == self.editMode?.wrappedValue {
                    HStack {
                        Spacer()
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100, alignment: .center)
                            .foregroundColor(Color(self.profile.wrappedColor))
                            .padding()
                        Spacer()
                    }
                } else {
                    UserIcon(profileColor: self.$profileColor)
                }
                
                HStack {
                    Text("Username")
                    
                    Spacer()
                    
                    TextField("Username", text: $username)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor((.active == self.editMode?.wrappedValue) ? Color.blue : Color.primary)
                        .multilineTextAlignment(.trailing)
                }
                
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
            }
            Section {
                if .inactive == self.editMode?.wrappedValue {
                    
                    Button {
                        withAnimation(.spring()) {
                            self.showingAge.toggle()
                        }
                    } label: {
                        HStack {
                            Text(self.showingAge ? "Age" : "Birthdate")
                            Spacer()
                            if self.showingAge {
                                Text(getAge(birthdate: self.profile.wrappedAge))
                            } else {
                                Text(self.profile.wrappedAge, formatter: Formatters.birthDateFormat)
                            }
                        }
                    }.foregroundColor(Color.primary)
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    HStack {
                        Text("Exam Duration")
                        Spacer()
                        Text("\(Int(self.profile.examDuration))s")
                    }
                } else {
                    
                    DatePicker("Birthdate", selection: $age, in: Formatters.closeBirthDateRange, displayedComponents: .date)
                        .multilineTextAlignment(.trailing)
                        .datePickerStyle(WheelDatePickerStyle())
                        
                    
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
                            self.activeSession.id = nil
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
        profile.age = self.age
        profile.examDuration = Float(self.examDuration)
        profile.profileColor = self.profileColor.rawValue
        
        try? self.viewContext.save()
        
        //self.presentationMode.wrappedValue.dismiss()
    }
}

//struct ProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileEditView()
//    }
//}
