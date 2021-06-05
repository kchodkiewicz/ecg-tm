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

class ExamArray: ObservableObject {
    @Published var array: [UInt8] = []
    
    func addToArray(data: [UInt8]) {
        self.array += data
    }
    
}

struct GraphExamView: View {

    @Environment(\.managedObjectContext) private var viewContext

    //@EnvironmentObject var stats: CardioStatistics

    @ObservedObject var bleConnection: BLEConnection
    @EnvironmentObject var graphData: GraphCal
    @State var isShowingAlert: Bool = false
    @State var examinationInProgress: Bool = false
    @State var goToExam: Bool = false
    @State var examinationStopped: Bool = false
    @State var countdown: Int = 6
    @State var placeholderTrigger: Bool = false
    //let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    @ObservedObject var profile: Profile

    @Binding var switchTab: Tab
    @Binding var goToBT: Bool?
    @State var exam: Exam?


    //@State var partialExamArray: [ChartDataEntry] = []
    //@State var examArray: [ChartDataEntry] = []

    @EnvironmentObject var examArray: ExamArray
    
    private func queueToSummary() {

        self.goToExam = true
    }

    private struct ComplexHeartRate {
        var rate: Int64 = -1
        var peaks: [Double] = []
    }

    private func calcHeartRate(samples: [Sample]) -> ComplexHeartRate {
        // peak if value greater than both neighbours and value
        // greater than 0.6

        var peaks: [Double] = []

        guard samples.count - 1 > 1 else {
            return ComplexHeartRate()
        }
        for index in 1 ..< samples.count - 1 {
            if (samples[index] > samples[index + 1] && samples[index] > samples[index - 1]) && samples[index].yValue >= 0.6 {
                peaks.append(samples[index].xValue)
            }
        }

        let duration = samples.count / 250
        guard duration != 0 else {
            return ComplexHeartRate()
        }
        let rate = Int64(Double(peaks.count) / Double(duration) * 60.0) // for bpm

        var complex = ComplexHeartRate()
        complex.rate = rate
        complex.peaks = peaks

        return complex
    }

    public func saveData() {
        //        DispatchQueue.global(qos: .background).async {
        print("Saving exam to CoreData")
        var samples: [Sample] = []

//        for chartData in examArray.array {
//            let sample = Sample(context: viewContext)
//            sample.id = UUID()
//            sample.xValue = Double(chartData.x)
//            sample.yValue = Double(chartData.y)
//            samples.append(sample)
//        }

        let stats = calcHeartRate(samples: samples)

        var peaks: [Peaks] = []

        let statsPeaks = stats.peaks // dunno if helpful
        print(statsPeaks) // dunno if helpful

        for index in 0..<statsPeaks.count {
            let peak = Peaks(context: viewContext)
            peak.id = UUID()
            peak.peakNo = Double(index)
            peak.xValue = statsPeaks[index] // dunno if helpful
            peaks.append(peak)
        }

        let exam = Exam(context: viewContext)
        exam.id = UUID()
        exam.date = Date()
        exam.heartRate = stats.rate
        exam.addToPeaks(NSSet(array: peaks))
        exam.addToSample(NSSet(array: samples))

        let profile = self.profile
        profile.addToExam(exam)
        do {
            try self.viewContext.save()

        } catch {
            print("Encountered problem while saving exam array")
            self.viewContext.rollback()
        }
        graphData.saveDataToDB()

        self.exam = exam
        //stats.recalculateMean(exam: exam)
        //}
    }

    func getEntries() -> [ChartDataEntry] {
        
        //print("tu se mam w Graph View received string: ", bleConnection.recievedString)
        let entries = graphData.addDataFromBT(data: bleConnection.recievedString)
        return entries

    }

    func sendStart() {
        //setCountdown()

        //DispatchQueue.global(qos: .utility).async {
            // Send examDuration to BT
            let commFrame = COMMFrame()
            commFrame.SetFrameID(frameID: 0x001)
            commFrame.SetAdditionalData(data: [COMMCommandType.SetDuringTimeECGTest.rawValue, UInt8(self.profile.examDuration)], size: 2)

            let frame = commFrame.GetFrameData()
            COMMFrameParser.SetCommandType(frameId: 0x001, type: COMMCommandType.SetDuringTimeECGTest)
            bleConnection.sendData(data: frame)
            print("[#] --- Has set Exam Duration")
        //}
        

        //TODO: change if broken
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let commFrame = COMMFrame()
            commFrame.SetFrameID(frameID: 0x001)
            commFrame.SetAdditionalData(data: [COMMCommandType.StartECGTest.rawValue], size: 1)

            let frame = commFrame.GetFrameData()
            COMMFrameParser.SetCommandType(frameId: 0x001, type: COMMCommandType.StartECGTest)

            bleConnection.sendData(data: frame)
            print("[*] --- Has started examination")
            self.examinationInProgress = true
        }
        //                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        //                            // Send Start signal to BT
        //
        //                        }
        // Start examination
        print("Start button")
    }

    func sendStop() {
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

    var body: some View {
        let vStack = VStack {

            Spacer()

                if self.examinationInProgress {
                    ECGGraph(entries: graphData.entries)
                } else {
                    //EmptyChartSplashView(triggerCountdown: $placeholderTrigger)
                }


            Spacer()


            Button(action: {
                if self.bleConnection.peripheral != nil {
                    if self.examinationInProgress {
                        withAnimation {
                            sendStop()
                        }

                    } else {
                        //withAnimation(.easeInOut(duration: 3.0)) {
                            sendStart()
                            //self.placeholderTrigger.toggle()
                        //}
                    }

                } else {
                    self.isShowingAlert = true
                }


            }, label: {
                Text(self.examinationInProgress ? "Stop" : "Start")

            })
            //                .onReceive(timer) { _ in
            //                    if countdown > 0 {
            //                        countdown -= 1
            //                    }
            //                }
            .buttonStyle(RoundButtonStyle(foregroundColor: self.examinationInProgress ? Color(.systemPink) : Color(.systemGreen)))


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
                        .padding(.top)
                }

        }
        return vStack
            .onReceive(self.bleConnection.passThroughSubjectPublisher) { result in

            print("Got some data")


            print("Count ", self.examArray.array.count, "Samples per second ", (Float(self.examArray.array.count) / self.profile.examDuration))
            if self.graphData.entries.count >= Int((self.profile.examDuration) * 200) || self.examinationStopped {

                print("Got full array")
                self.examinationStopped = false
                self.examinationInProgress = false
                countdown = 6

                saveData()
                self.examArray.array.removeAll()

                queueToSummary()
            } else {
                self.examArray.array += result
                _ = self.graphData.addDataFromBT(data: result)
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
