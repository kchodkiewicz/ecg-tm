//
//  OverView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import SwiftUI

struct OverView: View {
    
    @State private var showingNewExam: Bool = false
    @State private var showingProfile: Bool = false
    
    var body: some View {
//        NavigationView {
//
//            VStack(alignment: .leading) {
//
//                ScrollView(.vertical, showsIndicators: false) {
//
//                    VStack(alignment: .leading) {
//                        ForEach(profiles.examArray) { exam in
//
//                            HistoryRow(exam: exam)
//
//                        }
//
////                        // Full history
////                        NavigationLink(
////                            destination: HistoryView(userData: userData),
////                            label: {
////                                Text("Show full history")
////                                    .font(.headline)
////                            }
////                        )
//                    }
//                }
//
//            }
//            .layoutPriority(1)
//            .padding(.leading)
//            .navigationBarTitle(Text("Overview"))
//            .toolbar {
//                // Top Toolbar
//                ToolbarItem(placement: .primaryAction) {
//                    Button(action: {self.showingProfile.toggle()}) {
//                        Image(systemName: "person.crop.circle")
//                            .imageScale(.large)
//                            .accessibility(label: Text("User Profile"))
//                            .padding()
//                    }
//                }
//
//                ToolbarItem(placement: .bottomBar) {
//
//                    Button(action: {
//                        self.showingNewExam.toggle()
//                    }) {
//                        Image(systemName: "waveform.path.ecg.rectangle.fill")
//                            .imageScale(.large)
//                            .accessibility(label: Text("New Examination"))
//                            .padding()
//                    }
//
//                }
//
////                Button(action: addItem) {
////                    Label("Add Item", systemImage: "plus")
////                }
//            }
//            .sheet(isPresented: $showingNewExam) {
//                GraphExamView(userData: profiles)
//            }
//            .sheet(isPresented: $showingProfile) {
//                ProfileView(profile: profiles)
//            }
        
//        }
        Text("Hello World")
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView()
    }
}
