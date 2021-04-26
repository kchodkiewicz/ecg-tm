//
//  HistoryView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import CoreData
import SwiftUI

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    var fetchRequest: FetchRequest<Profile>
    var profile: FetchedResults<Profile> {
        fetchRequest.wrappedValue
    }
    
    //    @FetchRequest(
    //        entity: Exam.entity(),
    //        sortDescriptors: [
    //            NSSortDescriptor(keyPath: \ProgrammingLanguage.name, ascending: true),
    //        ],
    //        predicate: NSPredicate(format: "origin == %@", filter)
    //    ) var languages: FetchedResults<ProgrammingLanguage>
    
    var body: some View {
        
        List {
            
            ForEach(profile[0].examArray, id: \.self) { exam in
                HistoryRow(exam: exam)
            }
            .onDelete(perform: removeExam)
            .buttonStyle(PlainButtonStyle())
        }
        
        
        
        //        VStack(alignment: .leading) {
        //
        //            ScrollView(.vertical, showsIndicators: false) {
        //
        //                VStack(alignment: .leading) {
        //                    ForEach(profile[0].examArray) { exam in
        //                        HistoryRow(exam: exam)
        //                    }
        //                }
        //            }
        //        }
        
        .navigationTitle("Overview")
        
    }
    
    func removeExam(at offsets: IndexSet) {
        for index in offsets {
            let exam = profile[0].examArray[index]
            viewContext.delete(exam)
        }
        do {
            try viewContext.save()
        } catch {
            print("Some error happened to happed")
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<Profile>(entity: Profile.entity(), sortDescriptors: [], predicate: NSPredicate(format: "username == %@", filter), animation: .default)
        
        //        examFetchRequest = FetchRequest<Exam>(entity: Exam.entity(), sortDescriptors: [], predicate: NSPredicate(format: "origin == %@", fetchRequest.wrappedValue[0]), animation: .default)
        
        
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        HistoryView(userData: Profile())
//    }
//}
