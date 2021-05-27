//
//  GraphExamView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 09/03/2021.
//

import SwiftUI
import CoreData
import Charts
import Combine
import Foundation


struct GraphExamView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var stats: CardioStatistics
    @State var graphData = GraphCal()
    @ObservedObject var bleConnection: BLEConnection
    @State var isShowingAlert: Bool = false
    @State var countdown: Int = 6
    @State var examinationInProgress: Bool = false
    
    @ObservedObject var profile: Profile
    
    @Binding var switchTab: Tab
    @Binding var goToBT: Bool?
    @State var exam: Exam? // = Exam()
    @State var goToExam: Bool = false
    @State var examinationStopped: Bool = false
    
    @State var examArray: [ChartDataEntry] = []
    
    private func queueToSummary() {
        
        self.goToExam = true
    }
    
    public func saveData() {
        
        print("Zapisuję do CoreData")
        var samples: [Sample] = []
        
        for chartData in examArray {
            let sample = Sample(context: viewContext)
            sample.id = UUID()
            sample.xValue = Double(chartData.x)
            sample.yValue = Double(chartData.y)
            samples.append(sample)
        }
        
        let exam = Exam(context: viewContext)
        exam.id = UUID()
        exam.date = Date()
        exam.addToSample(NSSet(array: samples))
        
        let profile = self.profile
        profile.addToExam(exam)
        do {
            try self.viewContext.save()
            
        } catch {
            print("Encountered problem while updating exam array")
            self.viewContext.rollback()
        }
        graphData.saveDataToDB()
        
        self.exam = exam
        stats.recalculateMean(exam: exam)
        
    }
    
    func getEntries() -> [ChartDataEntry] {
        
        let entries = graphData.addDataFromBT(data: bleConnection.recievedString)
        
        return entries
        
    }
    
    func setCountdown() {
        withAnimation(.easeInOut) {
            for i in stride(from: 0.8, to: 5.7, by: 0.1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + i) {
                    if i == 5.6 {
                        self.countdown = 6
                    } else {
                        self.countdown -= 1
                    }
                }
            }
        }
    }
    
    var body: some View {
        let vStack = VStack {
            
            Spacer()
            ZStack {
                
                Chart(entries: getEntries())
                if !self.examinationInProgress {
                    EmptyChartSplashView()
                }
                //                if countdown > 0 && countdown < 6 {
                //                    Text("\(self.countdown)")
                //                        .font(.largeTitle)
                //                        .bold()
                //                        .transition(.scale)
                //                }
            }
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    if self.bleConnection.peripheral != nil {
                        if self.examinationInProgress {
                            self.examinationStopped = true
                            
                            // Send signal to BT
                            let commFrame = COMMFrame()
                            commFrame.SetFrameID(frameID: 0x001)
                            commFrame.SetAdditionalData(data: [COMMCommandType.StopECGTest.rawValue], size: 1)
                            print("Stop Button")
                            
                            let frame = commFrame.GetFrameData()
                            COMMFrameParser.SetCommandType(frameId: 0x001, type: COMMCommandType.StopECGTest)
                            
                            bleConnection.sendData(data: frame)
                        }
                    } else {
                        self.isShowingAlert = true
                    }
                    
                }, label: {
                    Text("Stop")
                    
                })
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 185/255, green: 45/255, blue: 45/255)))
                
                Spacer()
                Spacer()
                
                Button(action: {
                    if self.bleConnection.peripheral != nil {
                        //setCountdown()
                        self.examinationInProgress = true
                        
                        // Send signal to BT
                        let commFrame = COMMFrame()
                        commFrame.SetFrameID(frameID: 0x001)
                        commFrame.SetAdditionalData(data: [COMMCommandType.SetDuringTimeECGTest.rawValue, UInt8(self.profile.examDuration)], size: 2)
                        print(UInt8(self.profile.examDuration))
                        let frame = commFrame.GetFrameData()
                        COMMFrameParser.SetCommandType(frameId: 0x001, type: COMMCommandType.SetDuringTimeECGTest)
                        bleConnection.sendData(data: frame)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            let commFrame = COMMFrame()
                            commFrame.SetFrameID(frameID: 0x001)
                            commFrame.SetAdditionalData(data: [COMMCommandType.StartECGTest.rawValue], size: 1)
                            
                            let frame = commFrame.GetFrameData()
                            COMMFrameParser.SetCommandType(frameId: 0x001, type: COMMCommandType.StartECGTest)
                            
                            bleConnection.sendData(data: frame)
                        }
                    } else {
                        
                        self.isShowingAlert = true
                        
                    }
                    
                    // Start examination
                    print("Start button")
                    
                }, label: {
                    Text("Start")
                })
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 45/255, green: 185/255, blue: 185/255)))
                
                Spacer()
            }
            
            Spacer()
            Spacer()
                
                .alert(isPresented: self.$isShowingAlert) {
                    Alert(title: Text("Not connected to a device"), message: Text("Connect with device in profile settings"), primaryButton: .cancel(), secondaryButton: .default(Text("Go to settings"), action: {
                        withAnimation {
                            self.isShowingAlert = false
                            self.switchTab = .profile
                            self.goToBT = true
                        }
                    }))
                    
                }
                
                .sheet(isPresented: self.$goToExam) {
                    self.switchTab = .history
                    
                } content: {
                    GraphSummaryView(exam: self.profile.examArray[0], notes: self.profile.examArray[0].wrappedNotes, examType: ExamType(rawValue: self.profile.examArray[0].wrappedType) ?? ExamType.resting)
                }
            
        }
        return vStack.onReceive(self.graphData.passThroughSubjectPublisher) { result in
            
            print("Got some data")
            print("Count ", examArray.count, "Samples per second ", (Float(examArray.count) / self.profile.examDuration))
            if examArray.count >= Int((self.profile.examDuration) * 250) || self.examinationStopped {
                
                print("Got full array")
                //countdown = 6
                saveData()
                examArray.removeAll()
                self.examinationStopped = false
                self.examinationInProgress = false
                queueToSummary()
            } else {
                examArray += result
            }
            
        }
        
        .navigationTitle("Examination")
    }
}


//struct GraphExamView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        GraphExamView(userData: Profile())
//    }
//}
