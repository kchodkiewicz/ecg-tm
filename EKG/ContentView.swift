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
 * [ ] UserDefaults instead of ActiveSession
 * [ ] Id instead of Username
 * [ ] Fix form animation or give up
 * [ ] Remove user on long press
 
 
 --- OPTIONAL ---
 * [ ] Profile as sheet in Overview
 * [ ] Tabs: Overview, New Exam
 *
 
 */


import SwiftUI
import CoreData
import CoreBluetooth


struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get {self[ShowingSheetKey.self]}
        set {self[ShowingSheetKey.self] = newValue}
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var activeSession: ActiveSession
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.username, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<Profile>
    
    @State var username: String = ""
    @State private var showingNewUser: Bool = false

    
    var body: some View {
        
        if !activeSession.username.isEmpty && activeSession.profile != nil {
            
            let profile = profiles.filter { (Profile) -> Bool in
                Profile.id == activeSession.profile?.wrappedId
            }
            OverView(profile: profile[0])
                .environmentObject(activeSession)
            
        } else {
            VStack {
                Spacer()
                Text("ECG")
                    .font(.title)
                    .bold()
                Spacer()
                if self.profiles.isEmpty {
                    Image("logo")
                        .clipShape(Circle())
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.profiles) { profile in
                                VStack {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            activeSession.username = profile.username ?? ""
                                            
                                            activeSession.profile = profile
                                        }
                                        
                                    }, label: {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100, alignment: .center)
                                            .animation(.spring())
                                    })
                                    .foregroundColor(Color(ProfileColor.ColorName(value: profile.profileColor)))
                                    Text(profile.username ?? "-")
                                }
                            }
                        }.padding()
                    }.frame(alignment: .center)
                }
                
                Spacer()
                
                Button(action: {
                    self.showingNewUser.toggle()
                }, label: {
                    Text("New user")
                })
                .padding()
                .font(.headline)
                
                Spacer()
                    .sheet(isPresented: $showingNewUser, content: {
                        AddNewUserView().environment(\.showingSheet, self.$showingNewUser)
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
