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
    //@EnvironmentObject var stats: CardioStatistics
    @Binding var switchTab: Tab
    
    var fetchRequest: FetchRequest<Profile>
    var profile: FetchedResults<Profile> {
        fetchRequest.wrappedValue
    }
    
    
    
    var body: some View {
        Group {
            if !self.profile[0].examArray.isEmpty {
                List {
                    
                    ForEach(profile[0].examArray, id: \.self) { exam in
                        
                        HistoryRow(exam: exam, profile: profile[0])
                        
                    }
                    .onDelete(perform: removeExam)
                    .buttonStyle(PlainButtonStyle())
                }
                .listStyle(PlainListStyle())
            } else {
                Button {
                    switchTab = .exam
                } label: {
                    Text("Make first examination")
                }
            }
        }
        .navigationTitle("History")
        
    }
    
    func removeExam(at offsets: IndexSet) {
        
        
        DispatchQueue.global(qos: .background).async {
            viewContext.perform {
                for index in offsets {
                    let exam = profile[0].examArray[index]
                    viewContext.delete(exam)
                }
                do {
                    try viewContext.save()
                } catch {
                    viewContext.rollback()
                    print("Failed to remove user")
                }
            }
        }
    }
    
    init(filter: UUID, switchTab: Binding<Tab>) {
        fetchRequest = FetchRequest<Profile>(entity: Profile.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id == %@", filter as CVarArg), animation: .default)
        
        self._switchTab = switchTab
        
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        HistoryView(filter: "thebob")
//    }
//}
