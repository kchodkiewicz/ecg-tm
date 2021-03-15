//
//  ProfileSummaryView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 15/03/2021.
//
import CoreData
import SwiftUI

struct ProfileSummaryView: View {
    
    var fetchRequest: FetchRequest<Profile>
    var profile: FetchedResults<Profile> {
        fetchRequest.wrappedValue
    }
    
    var body: some View {
        List {
            Text("\(self.profile[0].wrappedFirstName) \(self.profile[0].wrappedLastName)")
                .bold()
                .font(.title)
            // TODO add notification toggle
            
            Text("First Name: \(self.profile[0].wrappedFirstName)")
            Text("Last Name: \(self.profile[0].wrappedLastName)")
            Text("Age: \(self.profile[0].age)")
            Text("Exam Duration: \(self.profile[0].examDuration)")
            
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<Profile>(entity: Profile.entity(), sortDescriptors: [], predicate: NSPredicate(format: "username == %@", filter), animation: .default)
    }
    
}

//struct ProfileSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSummaryView()
//    }
//}
