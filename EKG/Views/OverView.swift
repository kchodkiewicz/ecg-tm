//
//  OverView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import SwiftUI

struct OverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var activeSession: ActiveSession
    
//    @FetchRequest(
//        entity: Profile.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.id, ascending: true)],
//        animation: .default)
//    private var profile: FetchedResults<Profile>
    
    var profile: Profile
    
    @State private var showingNewExam: Bool = false
    @State private var showingProfile: Bool = false
    
    var body: some View {
        NavigationView {

            HistoryView(filter: activeSession.username)
            .layoutPriority(1)
            .padding(.leading)
            .navigationBarTitle(Text("Overview"))
            .toolbar {
                // Top Toolbar
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {self.showingProfile.toggle()}) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                            .accessibility(label: Text("User Profile"))
                            .padding()
                    }
                }

                ToolbarItem(placement: .bottomBar) {

                    Button(action: {
                        //self.showingNewExam.toggle()
                        
                        // FOR TESTING ONLY -----------
                        var samples: [Sample] = []
                        for i in 0...10 {
                            let sample = Sample(context: viewContext)
                            sample.id = UUID()
                            sample.xValue = Int64(i)
                            sample.yValue = Int64(Int.random(in: 0...200))
                            samples.append(sample)
                            
                            try? self.viewContext.save()
                        }
                        
                        
                        let exam = Exam(context: viewContext)
                        exam.id = UUID()
                        exam.date = Date()
                        exam.sample = NSSet(object: samples)
                        
                        try? self.viewContext.save()
                        // ---------------------------
                        
                    }) {
                        Image(systemName: "waveform.path.ecg.rectangle.fill")
                            .imageScale(.large)
                            .accessibility(label: Text("New Examination"))
                            .padding()
                    }

                }
            }
//            .sheet(isPresented: $showingNewExam) {
//                GraphExamView()
//            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
                    .environmentObject(self.activeSession)
                
            }
        }
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView()
//    }
//}
