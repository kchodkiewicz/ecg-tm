//
//  ContentView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

/* *** TODO ***
 
 LEGEND:
 - * DONE
 - # Clumsy
 - ~ Abandoned
 
 * [*] Title spacing
 * [*] Exam rebuild - not requiring samples
 * [*] Profile age
 * [*] Profile looks
 * [*] History previews
 * [*] User profile color / photo
 * [*] Id instead of Username
 * [*] Remove user on long press
 * [*] Fix editmode on first new user
 * [*] Beautify UserRemovalOverlay
 * [*] Fix ScrollView hit only on text
 * [#] Centered ScrollView
 * [~] UserDefaults instead of ActiveSession - chyba nie (UserDefaults przeżywa restart)
 * [ ] Fix form animation or give up
 * [ ] History Row images
 
 
 --- OPTIONAL ---
 * [ ] Profile as sheet in Overview
 * [ ] Tabs: Overview (pulse, etc. + part of history), History, New Exam
 *
 
 */


import SwiftUI
import CoreData
import CoreBluetooth


//extension View {
//    func animate(using animation: Animation = Animation.linear(duration: 0.1), _ action: @escaping () -> Void) -> some View {
//        onAppear {
//            withAnimation(animation) {
//                action()
//            }
//        }
//    }
//}
//
//extension View {
//    func animateForever(using animation: Animation = Animation.linear(duration: 0.1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
//        let repeated = animation.repeatForever(autoreverses: autoreverses)
//        return onAppear {
//            withAnimation(repeated) {
//                action()
//            }
//        }
//    }
//}


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
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var activeSession: ActiveSession
    @Environment(\.editMode) var editMode
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.username, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<Profile>
    
    //@State var username: String = ""
    
    @State private var isShowingAddUser: Bool = false
    
//    @State var shake: Double = 0.0
//    @State var move: Double = 0.0
    
    @State var profile: Profile = Profile()
    
    @State var isUserSet: Bool = false
    
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
        
        //NavigationView {
//            if let session = activeSession.id {
//                //MARK: - Queue to Overview
//                let profile = profiles.filter { (Profile) -> Bool in
//                    Profile.id == session
//                }
//                OverView(profile: profile[0])
//
//
//            } else {
            
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
                            .transition(.logoMove)
                        
                        Text("ECG")
                            .foregroundColor(.white)
                            .font(self.profiles.isEmpty ? .largeTitle : .title)
                            .bold()
                            .shadow(color: .black, radius: self.profiles.isEmpty ? 3.0 : 0.0, x: 0.0, y: 0.0)
                            .transition(.logoMove)
                    }
                    
                    //MARK:  Users Scroll View
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.profiles) { profile in
                                VStack() {
                                    ZStack {
                                        Button(action: {
                                            //withAnimation(.spring()) {
                                                if self.editMode?.wrappedValue == .inactive {
                                                    activeSession.id = profile.wrappedId
                                                    if let session = activeSession.id {
                                                        //MARK: - Queue to Overview
                                                        let filteredProfile = profiles.filter { (Profile) -> Bool in
                                                            Profile.id == session
                                                        }
                                                        self.profile = filteredProfile[0]
                                                        self.isUserSet.toggle()
                                                        
                                                    }
                                                }
                                            //}
                                        },
                                        label: {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .frame(width: userIconSize, height: userIconSize, alignment: .center)
                                            
                                        }).buttonStyle(PlainButtonStyle())
                                        
                                        .contextMenu {
                                            //FIXME: fix contextMenu shadow (circle indead of rectangle)
                                            VStack {
                                                Button {
                                                    withAnimation(.default) {
                                                        
                                                        //self.shake = -.pi/60
                                                        
                                                        self.editMode?.wrappedValue = .active
                                                        
                                                        //print(self.shake)
                                                        print(self.editMode?.wrappedValue == .active)
                                                    }
                                                } label: {
                                                    Label("Edit users", systemImage: "pencil")
                                                    
                                                }
                                                
                                                Button {
                                                    withAnimation(.default) {
                                                        removeProfile(at: profile.id!)
                                                    }
                                                } label: {
                                                    Label("Remove  \(profile.username ?? "user")", systemImage: "trash")
                                                }
                                            }
                                        }
                                        .foregroundColor(Color(profile.wrappedColor))
                                        
                                        if self.editMode?.wrappedValue == .active {
                                            Button(action: {
                                                withAnimation(.default) {
                                                    removeProfile(at: profile.id!)
                                                }
                                            },
                                            label: {
                                                UserRemovalOverlay(size: userIconSize)
                                            }).offset(x: -(userIconSize / 3), y: -(userIconSize / 3))
                                            .foregroundColor(Color(profile.wrappedColor))
                                        }
                                        
                                    }
                                    Text(profile.wrappedUsername)
                                }
                                //TODO: try adding jiggle in editMode
                                //                            .rotationEffect(self.editMode?.wrappedValue == .active ? .radians(self.shake) : .radians(0.0))
                                //                            .animateForever(autoreverses: true) {
                                //                                if self.editMode?.wrappedValue == .active {
                                //                                    self.shake += .pi/30
                                //                                    self.move += .pi/6
                                //                                }
                                //                                print(shake)
                                //                            }
                                
                                //                            if self.editMode?.wrappedValue == .active {
                                //                                .offset(x: CGFloat(4 * sin(self.move)), y: CGFloat(4 * cos(self.move)))
                                //                                .rotationEffect(.radians(shake))
                                //                                .animateForever(autoreverses: true) {
                                //                                    shake += .pi/30
                                //                                    move += .pi/6
                                //                                }
                                //                            }
                                
                            }
                        }.padding(.horizontal, gemetricalPadding)
                    }
                    Spacer()
                    
                    //MARK:  New User / Done Button
                    Button(action: {
                        withAnimation(.default) {
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
                    .sheet(isPresented: $isShowingAddUser, content: {
                        AddNewUserView()
                    })
                    .padding()
                    .font(.headline)
                    
                    Spacer()
                        
                        
                        .fullScreenCover(isPresented: $isUserSet) {
                            OverView(profile: self.profile, dismiss: self.$isUserSet)
                        }
                        
//                    NavigationLink(destination: OverView(profile: self.profile ?? profiles[0]), tag: true, selection: $isUserSet) {
//                        EmptyView()
//                    }
                   
//                    .navigationBarTitle("")
//                    .navigationBarHidden(true)
                }
                
                
            //}
        //}
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
