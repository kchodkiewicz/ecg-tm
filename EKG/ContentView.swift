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
 * [*] Fix editmode on first new user
 * [ ] Beautify UserRemovalOverlay
 * [*] Fix ScrollView hit only on text
 * [#] Centered ScrollView
 
 
 --- OPTIONAL ---
 * [ ] Profile as sheet in Overview
 * [ ] Tabs: Overview (pulse, etc. + part of history), History, New Exam
 *
 
 */


import SwiftUI
import CoreData
import CoreBluetooth

struct LogoOverlay: View {
    
    var isOverlaying: Bool
    
    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .bottom, endPoint: .top))
            .opacity(self.isOverlaying ? 0.7 : 0.0)
    }
}

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
            print("Couldn't remove user at index: \(index)")
        }
    }
    
    //TODO: change hardcoded padding
    let userIconPadding: CGFloat = 10
    
    var gemetricalPadding: CGFloat {
        let icons = UIScreen.main.bounds.width - userIconSize * CGFloat(self.profiles.count)
        let paddings = (CGFloat(self.profiles.count) - 1) * userIconPadding
        let finalPadding = (icons - paddings) / 2.0
        guard finalPadding > 0 else {
            return 0.0
        }
        return finalPadding
    }
    
    var userIconSize: CGFloat {
        let iconsOnScreen: CGFloat = 3.0
        return (UIScreen.main.bounds.width / iconsOnScreen) - userIconPadding / 2.0
    }
    
    //MARK: - Body
    var body: some View {
        
        
        if let session = activeSession.id {
            //MARK: - Queue to Overview
            let profile = profiles.filter { (Profile) -> Bool in
                Profile.id == session
            }
            OverView(profile: profile[0])
            
        } else {
            //MARK: - Choose User View
            VStack {
                Spacer()
                
                //MARK:  Logo & Name
                ZStack {
                    Image("logo")
                        .overlay(self.profiles.isEmpty ? LogoOverlay(isOverlaying: false) : LogoOverlay(isOverlaying: true))
                        .clipShape(Circle())
                        .offset(x: 0.0, y: self.profiles.isEmpty ? 100.0 : -30.0)
                        .shadow(color: .black, radius: self.profiles.isEmpty ? 3.0 : 0.0, x: 0.0, y: 0.0)
                        .animation(.spring())
                        .transition(Transitions.viewTransition)
                    
                    Text("ECG")
                        .foregroundColor(.white)
                        .font(self.profiles.isEmpty ? .largeTitle : .title)
                        .bold()
                        .shadow(color: .black, radius: self.profiles.isEmpty ? 3.0 : 0.0, x: 0.0, y: 0.0)
                        .animation(.spring())
                        .transition(Transitions.viewTransition)
                }
                
                //MARK:  Users Scroll View
                
                //FIXME: fix animations when deleting users
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.profiles) { profile in
                            VStack {
                                if self.editMode?.wrappedValue == .inactive {
                                    
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            activeSession.id = profile.wrappedId
                                        }
                                    },
                                    label: {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: userIconSize, height: userIconSize, alignment: .center)
                                            .animation(.spring())
                                    })
                                    //FIXME: fix contextMenu shadow (circle indead of rectangle)
                                    .contextMenu {
                                        VStack {
                                            Button {
                                                withAnimation(.spring()) {
                                                    self.editMode?.wrappedValue = .active == self.editMode?.wrappedValue ? .inactive : .active
                                                }
                                            } label: {
                                                Label("Edit users", systemImage: "pencil")
                                                
                                            }
                                            Button {
                                                withAnimation(.spring()) {
                                                    removeProfile(at: profile.id!)
                                                }
                                            } label: {
                                                Label("Remove  \(profile.username ?? "user")", systemImage: "trash")
                                            }
                                        }
                                    }
                                    .foregroundColor(Color(profile.wrappedColor))
                                    Text(profile.wrappedUsername)
                                } else {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            removeProfile(at: profile.id!)
                                        }
                                    },
                                    label: {
                                        ZStack {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .frame(width: userIconSize, height: userIconSize, alignment: .center)
                                                .animation(.spring())
                                            
                                            UserRemovalOverlay(size: userIconSize)
                                        }
                                    })
                                    .foregroundColor(Color(profile.wrappedColor))
                                    Text(profile.wrappedUsername)
                                }
                            }.padding(0.0)
                        }
                    }.padding(.horizontal, gemetricalPadding)
                }
                Spacer()
                
                //MARK:  New User / Done Button
                Button(action: {
                    withAnimation(.spring()) {
                        if !self.profiles.isEmpty {
                            if self.editMode?.wrappedValue == .inactive {
                                self.isShowingAddUser.toggle()
                            } else {
                                self.editMode?.wrappedValue = .inactive
                            }
                        } else {
                            self.editMode?.wrappedValue = .inactive
                            self.isShowingAddUser.toggle()
                        }
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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
