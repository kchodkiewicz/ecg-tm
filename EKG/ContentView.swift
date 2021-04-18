//
//  ContentView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

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
    
    private func getRandomColor() -> Color {
        let colorList = [Color.red, Color.blue, Color.green, Color.yellow]
        
        return colorList.randomElement()!
    }
    
    var body: some View {
        
        NavigationView {
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.profiles) { profile in
                                VStack {
                                    Button(action: {
                                        activeSession.username = profile.username ?? ""
                                        
                                        activeSession.profile = profile
                                    }, label: {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100, alignment: .center)
                                    })
                                    .foregroundColor(getRandomColor())
                                    Text(profile.username ?? "-")
                                }
                            }
                        }.frame(alignment: .center)
                    }
                    
                    
                    Spacer()
                    
                    TextField("Username", text: $username)
                        .frame(maxWidth: 200, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.all)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.25), radius: 3, y: 2)
                    
                    Button {
                        activeSession.username = username
                        activeSession.profile = self.profiles.filter({ (Profile) -> Bool in
                            Profile.username == username
                        })[0]
                    } label: {
                        Text("Login")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: 200)
                    .padding(.all)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.25), radius: 3, y: 2)
                    
                    
                    Button(action: {
                        self.showingNewUser.toggle()
                    }, label: {
                        Text("New user")
                    })
                    .padding()
                    .font(.caption)
                    
                    Spacer()
                    
                    
                    .sheet(isPresented: $showingNewUser, content: {
                        AddNewUserView().environment(\.showingSheet, self.$showingNewUser)
                    })
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Profile(context: viewContext)
            newItem.firstName = ""

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
