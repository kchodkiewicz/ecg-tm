//
//  ProfileEditView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 11/03/2021.
//
import SwiftUI
import CoreData
import CoreBluetooth


struct ProfileEditView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    var viewContext: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var profile: Profile
    
    @ObservedObject var bleConnection: BLEConnection
    
    @Environment(\.editMode) var editMode
    //@EnvironmentObject var activeSession: ActiveSession
    
    
    
    //TODO: Animate and make less clumsy
    @Binding var goToBluetooth: Bool?
    @Binding var dismiss: Bool
    
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var age: Date = Date()
    @State var examDuration: Int = 5
    @State var profileColor: ProfileColor = ProfileColor.crimson
    
    @State var isShowingPallette: Bool = false
    @State var isShowingAge: Bool = true
    
    
    var body: some View {
        
        Form {
            
            if .inactive == self.editMode?.wrappedValue {
                Section{
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
                }
            } else {
                Section {
                    UserIcon(isShowingPallette: self.$isShowingPallette, profileColor: self.$profileColor)
                }
            }
            
            Section {
                HStack {
                    Text("Username")
                    
                    Spacer()
                    
                    TextField("Username", text: $username)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor(.inactive == self.editMode?.wrappedValue ? Color.primary : Color.blue)
                        .multilineTextAlignment(.trailing)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                
                HStack {
                    Text("First Name")
                    
                    Spacer()
                    
                    TextField("First Name", text: $firstName)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor(.inactive == self.editMode?.wrappedValue ? Color.primary : Color.blue)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Last Name")
                    
                    Spacer()
                    
                    TextField("Last Name", text: $lastName)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor(.inactive == self.editMode?.wrappedValue ? Color.primary : Color.blue)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            if .inactive == self.editMode?.wrappedValue {
                Section {
                    Button {
                        withAnimation(.spring()) {
                            self.isShowingAge.toggle()
                        }
                    } label: {
                        HStack {
                            Text(self.isShowingAge ? "Age" : "Birthdate")
                            
                            Spacer()
                            
                            if self.isShowingAge {
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
                }
            } else {
                Section {
                    DatePicker("", selection: $age, in: Formatters.closeBirthDateRange, displayedComponents: .date)
                        .multilineTextAlignment(.trailing)
                        .datePickerStyle(WheelDatePickerStyle())
                }
                Section {
                    Stepper("\(examDuration) seconds", value: $examDuration, in: 1...60)
//                        .disabled(.inactive == self.editMode?.wrappedValue)
//                        .foregroundColor(.inactive == self.editMode?.wrappedValue ? Color.primary : Color.blue)
                }
            }
            
            
            if self.editMode?.wrappedValue == .inactive {
                Section {
                    
                    NavigationLink(destination: BTView(profile: profile, bleConnection: bleConnection), tag: true, selection: self.$goToBluetooth) {
                        Text("Bluetooth Device")
                        
                        Spacer()
                        
                        Text(bleConnection.peripheral?.name ?? "None")
                    }
                }
                Section {
                    
                    Button {
                        //withAnimation(.easeInOut(duration: 0.35)) {
                            //self.activeSession.id = nil
                            //self.isLoggedIn = false
                        //print("Switching, wrappedValue: \(self.presentationMode.wrappedValue)")
                        //self.presentationMode.wrappedValue.dismiss()
                        self.dismiss.toggle()
                        //}
                    } label: {
                        Text("Switch User")
                    }
                }
            }
//            else {
//            
//                Section { }
//                Section { }
//                if self.isShowingPallette {
//                    Section { }
//                }
//            }
        }
        
        //.listStyle(GroupedListStyle())
        .navigationBarItems(
            leading: Button(action: {
                withAnimation {
                    self.editMode?.wrappedValue = .inactive == self.editMode?.wrappedValue ? .active : .inactive
                }
            }) {
                Text(.inactive == self.editMode?.wrappedValue ? "" : "Cancel")
            }
            .padding(.vertical)
            .padding(.trailing),
            
            trailing: Button(action: {
                withAnimation {
                    if !(self.editMode?.wrappedValue == .inactive) {
//                        if self.isShowingPallette {
//                            self.isShowingPallette.toggle()
//                        }
                        updateProfile()
                    }
                    self.editMode?.wrappedValue = .inactive == self.editMode?.wrappedValue ? .active : .inactive
                }
            }) {
                Text(.inactive == self.editMode?.wrappedValue ? "Edit" : "Done")
            }
            .padding(.vertical)
            .padding(.leading)
        )
        
        .navigationTitle(.inactive == self.editMode?.wrappedValue ? "\(self.firstName) \(self.lastName)" : "Edit your profile")
        
    }
    
    private func getAge(birthdate: Date) -> String {
        
        let current = Calendar.current
        let years = current.dateComponents(
            [.year],
            from: birthdate,
            to: Date()
        )
        return String(years.year!)
    }
    
    private func updateProfile() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let profile = self.profile
        profile.username = self.username
        profile.firstName = self.firstName
        profile.lastName = self.lastName
        profile.age = self.age
        profile.examDuration = Float(self.examDuration)
        profile.profileColor = self.profileColor.rawValue
        do {
        try self.viewContext.save()
        } catch {
            print("Fuck")
            self.viewContext.rollback()
        }
    }
}
