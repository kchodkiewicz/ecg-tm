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
    
//    var fetchRequest: FetchRequest<Profile>
//    var profile: FetchedResults<Profile> {
//        fetchRequest.wrappedValue
//    }
    
    @ObservedObject var profile: Profile
    
    
    var body: some View {
        Group {
            if !self.profile.examArray.isEmpty {
                List {
                    
                    ForEach(profile.examArray, id: \.self) { exam in
                        
                        HistoryRow(exam: exam, profile: profile)
                        
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

            viewContext.perform {
                for index in offsets {
                    let exam = profile.examArray[index]
                    viewContext.delete(exam)
                }
        
                do {
                    try viewContext.save()
                } catch {
                    print("Failed to remove user")
                    viewContext.rollback()

                }
            }
    }
    
    init(profile: Profile, switchTab: Binding<Tab>) {
        
        self.profile = profile
        
        self._switchTab = switchTab
        
    }
}

