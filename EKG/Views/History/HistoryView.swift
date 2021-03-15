//
//  HistoryView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import CoreData
import SwiftUI

struct HistoryView: View {
    var fetchRequest: FetchRequest<Profile>
    var profile: FetchedResults<Profile> {
        fetchRequest.wrappedValue
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {

            ScrollView(.vertical, showsIndicators: false) {

                VStack(alignment: .leading) {
                    ForEach(profile[0].examArray) { exam in
                        HistoryRow(exam: exam)
                    }
                }
            }
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<Profile>(entity: Profile.entity(), sortDescriptors: [], predicate: NSPredicate(format: "username == %@", filter), animation: .default)
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        HistoryView(userData: Profile())
//    }
//}
