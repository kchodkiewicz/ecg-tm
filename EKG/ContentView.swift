//
//  ContentView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

/* *** TODO ***
 
 * [*] Title spacing
 * [*] Exam rebuild - not requiring samples
 * [*] Profile age
 * [*] Profile looks
 * [*] History previews
 * [ ] History Row images
 * [*] User profile color / photo
 * [ ] UserDefaults instead of ActiveSession - chyba nie (UserDefaults przeżywa restart)
 * [*] Id instead of Username
 * [ ] Fix form animation or give up
 * [*] Remove user on long press
 * [ ] Fix editmode on first new user
 * [ ] Beautify UserRemovalOverlay
 * [ ] Fix ScrollView hit only on text
 
 
 --- OPTIONAL ---
 * [ ] Profile as sheet in Overview
 * [ ] Tabs: Overview (pulse, etc. + part of history), History, New Exam
 *
 
 */


import SwiftUI
import CoreData
import CoreBluetooth


//struct ShowingSheetKey: EnvironmentKey {
//    static let defaultValue: Binding<Bool>? = nil
//}

//extension EnvironmentValues {
//    var showingSheet: Binding<Bool>? {
//        get {self[ShowingSheetKey.self]}
//        set {self[ShowingSheetKey.self] = newValue}
//    }
//}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var activeSession: ActiveSession
    @Environment(\.editMode) var editMode
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.username, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<Profile>
    
    @State var username: String = ""
    
    @State private var isShowingAddUser: Bool = false
    
    func removeProfile(at offset: UUID) {
        let index = profiles.firstIndex{ (Profile) -> Bool in
            Profile.id == offset
        }!
        
        let profile = profiles[index]
        viewContext.delete(profile)
        
        do {
            try viewContext.save()
        } catch {
            print("Some error happened to happed")
        }
    }
    
    var body: some View {
        
        if let session = activeSession.id {
            
            let profile = profiles.filter { (Profile) -> Bool in
                Profile.id == session
            }
            OverView(profile: profile[0])
            
        } else {
            VStack {
                Spacer()
                
                ZStack {
                    Image("logo")
                        .clipShape(Circle())
                        .offset(x: 0.0, y: self.profiles.isEmpty ? 100.0 : 0.0)
                        .animation(.spring())
                        .transition(Transitions.viewTransition)
                    
                    Text("ECG")
                        .font(self.profiles.isEmpty ? .largeTitle : .title)
                        .bold()
                        .transition(Transitions.viewTransition)
                    
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.profiles) { profile in
                            VStack {
                                if self.editMode?.wrappedValue == .inactive {
                                    
                                    Button(action: {},
                                           label: {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .frame(width: 100, height: 100, alignment: .center)
                                                .animation(.spring())
                                            
                                           })
                                        .simultaneousGesture(LongPressGesture().onEnded { _ in
                                            print("Secret Long Press Action!")
                                            
                                            withAnimation(.spring()) {
                                                self.editMode?.wrappedValue = .active == self.editMode?.wrappedValue ? .inactive : .active
                                            }
                                        })
                                        .simultaneousGesture(TapGesture().onEnded {
                                            withAnimation(.spring()) {
                                                print("Boring regular tap")
                                                activeSession.id = profile.wrappedId
                                            }
                                        })
                                        .foregroundColor(Color(profile.wrappedColor))
                                    Text(profile.wrappedUsername)
                                } else {
                                    Button(action: {},
                                           label: {
                                            ZStack {
                                                Image(systemName: "person.circle")
                                                    .resizable()
                                                    .frame(width: 100, height: 100, alignment: .center)
                                                    .animation(.spring())
                                                    .onLongPressGesture {
                                                        self.editMode?.wrappedValue = .active == self.editMode?.wrappedValue ? .inactive : .active
                                                    }
                                                
                                                UserRemovalOverlay()
                                            }
                                           })
                                        .simultaneousGesture(TapGesture().onEnded {
                                            withAnimation(.spring()) {
                                                print("DeleteButton with no effect")
                                                removeProfile(at: profile.id!)
                                            }
                                        })
                                        .foregroundColor(Color(profile.wrappedColor))
                                    Text(profile.wrappedUsername)
                                }
                            }
                        }
                    }.padding()
                }.frame(alignment: .center)
                
                
                Spacer()
                
                Button(action: {
                    if !self.profiles.isEmpty {
                        if self.editMode?.wrappedValue == .inactive {
                            self.isShowingAddUser.toggle()
                        } else {
                            self.editMode?.wrappedValue = .inactive
                        }
                    } else {
                        self.isShowingAddUser.toggle()
                    }
                }, label: {
                    Text(self.profiles.isEmpty ? "New user" : self.editMode?.wrappedValue == .inactive ? "New user" : "Done")
                })
                .padding()
                .font(.headline)
                
                Spacer()
                    .sheet(isPresented: $isShowingAddUser, content: {
                        AddNewUserView()
                    })
            }
            .onAppear(perform: {self.editMode?.wrappedValue = .inactive})
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
