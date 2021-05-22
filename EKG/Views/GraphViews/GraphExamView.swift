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

struct RoundButtonStyle: ButtonStyle {
    
    let foregroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(configuration.isPressed ? Color.clear : foregroundColor)
                .frame(width: 55, height: 55)
                .padding(10)
            Circle()
                .stroke(foregroundColor, lineWidth: 3.0)
                .frame(width: 63, height: 63)
            
            configuration.label
                .frame(width: 63, height: 63)
                .foregroundColor(configuration.isPressed ? Color.secondary : Color.white)
                .clipShape(configuration.isPressed ? Circle() : Circle())
        }
    }
}


struct GraphExamView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var graphData = GraphCal()
    @ObservedObject var bleConnection: BLEConnection
    @State var isShowingAlert: Bool = false
    @State var countdown: Int = 6
    
    let profile: Profile
    
    @Binding var switchTab: Tab
    @Binding var goToBT: Bool?
    
    private func queueToSummary() {
        //TODO: Queue to GraphSummaryView if stopButton or examDuration exceeded
    }
    
    public func saveData() {
        
        print("Zapisuję do CoreData")
        var samples: [Sample] = []
        
        for chartData in graphData.entries {
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
        
        try? self.viewContext.save()
        graphData.saveDataToDB()
        
        
    }
    func getEntries() -> [ChartDataEntry] {
        
        let entries = graphData.addDataFromBT(data: bleConnection.recievedString)
//        if bleConnection.finishedExamination {
//            saveData()
//            bleConnection.finishedExamination = false
//            //countdown = 6
//        }
        return entries
        
    }
    
    func setCountdown() {
        withAnimation(.easeInOut) {
            for i in stride(from: 0.8, to: 5.7, by: 0.8) {
                DispatchQueue.main.asyncAfter(deadline: .now() + i) {
                    if i == 5.6 {
                        self.countdown = 6
                    } else {
                        self.countdown -= 1
                    }
                }
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
//                self.countdown -= 1
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
//                self.countdown -= 1
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
//                self.countdown -= 1
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                self.countdown -= 1
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4.8) {
//                self.countdown -= 1
//            }
        }
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            ZStack {
                
                Chart(entries: getEntries())
                
                if countdown > 0 && countdown < 6 {
                    Text("\(self.countdown)")
                        .font(.largeTitle)
                        .bold()
                        .transition(.scale)
                }
            }
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    
                    //TODO: Send stop signal to BT
                    
                    // Stop examination
                    print("Stop button")
                    
                    
                    
                }, label: {
                    Text(bleConnection.finishedExamination ? "End" : "Stop")
                    
                })
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 185/255, green: 45/255, blue: 45/255)))
                
                Spacer()
                Spacer()
                
                Button(action: {
                    if self.bleConnection.peripheral != nil {
                        setCountdown()
                        
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
                        
//                        DispatchQueue.async {
//                            while true {
//                                if self.bleConnection.finishedExamination {
//                                    saveData()
//                                    break
//                                }
//                            }
//                        }
                    } else {
                        self.isShowingAlert = true
                    }
                    
                   
                    
                    
                    // Start examination
                    print("Start button")
                    
                    // FOR TESTING ONLY -----------
                    //                    var samples: [Sample] = []
                    //                    for i in 0...Int(250 * Float(profile.examDuration )) {
                    //                        let sample = Sample(context: viewContext)
                    //                        sample.id = UUID()
                    //                        sample.xValue = Int64(i)
                    //                        sample.yValue = Int64(Int.random(in: 0...1023))
                    //                        samples.append(sample)
                    //                    }
                    //
                    //                    let exam = Exam(context: viewContext)
                    //                    exam.id = UUID()
                    //                    exam.date = Date()
                    //                    exam.addToSample(NSSet(array: samples))
                    //
                    //                    let profile = self.profile
                    //                    profile.addToExam(exam)
                    //
                    //                    try? self.viewContext.save()
                    // ---------------------------
                    
                    
                    
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
        }
//        .onReceive(bleConnection.examinationhasFinished, perform: { _ in
//            countdown = 6
//            saveData()
//            bleConnection.finishedExamination = false
//            bleConnection.examinationhasFinished.send(false)
//
//        })
        
//        .onChange(of: graphData, perform: { _ in
//            if bleConnection.finishedExamination {
//                saveData()
//                bleConnection.finishedExamination = false
//            }
//        })
            
        
        .navigationTitle("Examination")
    }
}


//struct GraphExamView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        GraphExamView(userData: Profile())
//    }
//}
