//
//  HistoryOverview.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI
import Foundation


struct SelectedRange {
    var lowerBound: Date = Date()
    var upperBound: Date = Date()
}

struct SummarySection: View {
    
    var labelName: String
    var labelIcon: String
    var color: UIColor
    var selectedRange: SelectedRange
    var values: [Int]
    var units: [String]
    
    var body: some View {
        Section {
            VStack {
                HStack {
                    Label(labelName, systemImage: labelIcon)
                        .labelStyle(CompressedLabelStyle(labelColor: color))
                    Spacer()
                    
                    Text("\(Formatters.withoutYear(date: self.selectedRange.lowerBound)) - \(Formatters.withoutYear(date: self.selectedRange.upperBound))")
                        .font(.body)
                        .foregroundColor(Color(.secondaryLabel))
                }
                Spacer()
                if values.count == 1 {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text("\(values[0])")
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                        Text(units[0])
                            .font(.title2)
                            .bold()
                            .foregroundColor(.secondary)
                        Spacer()
                        
                    }.padding(.leading)
                } else {
                    HStack {
                        ForEach(0..<self.values.count) { index in
                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Text("\(values[index])")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .bold()
                                Text(units[index])
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.secondary)
                                Spacer()

                            }.padding(.leading)
                        }
                    }
                }
                
            }
            .padding()
            
        }
    }
}

struct HistoryOverview: View {
    
    @ObservedObject var profile: Profile
    @Binding var switchTab: Tab
    var selectPeriod: TimePeriod
    
    @State var lastPeriodExams: [Exam] = []
    @State var filteredExams: [Exam] = []
    @State var selectedRange: SelectedRange = SelectedRange()
    @State var means: MeanStats = MeanStats()
    
    struct MeanStats {
        
        var heartrate: Int64 = 0
        var interval: Double = 0.0
        var iqr: Double = 0.0
        var examType: (Int, Int) = (0, 0)
        
    }
    
    func calculateMeans() -> MeanStats {
        
        guard lastPeriodExams.count > 0 else {
            return MeanStats()
        }
        
        var means = MeanStats()
        
        let sumHeartRate: Int64 = {
            var sum: Int64 = 0
            for exam in lastPeriodExams {
                sum += exam.heartRate
            }
            return sum
        }()
        
        means.heartrate = sumHeartRate / Int64(lastPeriodExams.count)
        
        let sumExamType: (Int, Int) = {
            
            let resting = lastPeriodExams.filter { Exam in
                Exam.type == "resting"
            }.count
            
            let stress = lastPeriodExams.filter { Exam in
                Exam.type == "stress"
            }.count
            
            return (resting, stress)
            
        }()
        
        means.examType = sumExamType
        
        var sumStats: (Double, Double) = (0.0, 0.0)
        
        for exam in lastPeriodExams {
            let stats = CardioStats(exam: exam).getStats()
            sumStats.0 += stats.meanTime
            sumStats.1 += stats.variation
        }
        
        means.interval = sumStats.0 / Double(lastPeriodExams.count)
        means.iqr = sumStats.1 / Double(lastPeriodExams.count)
        
        return means
        
    }
    
    func makeString(int: Int, string: String) -> String {
        return String(int) + string
    }
    
    var body: some View {
        Group {
            if !self.filteredExams.isEmpty {

                Form {
                    Section {
                        VStack {
                            HStack {
                        Label("Electrocardiogram", systemImage: "waveform.path.ecg")
                            .labelStyle(CompressedLabelStyle(labelColor: .systemPurple))
                        
                                Spacer()
                                
                                Text("\(Formatters.withoutYear(date: self.filteredExams.first!.wrappedDate)) - \(Formatters.withoutYear(date: self.filteredExams.last!.wrappedDate))")
                                    .font(.body)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            .padding()
                            
                        TabView {

                            ForEach(self.filteredExams) { exam in
                                RecentExamTab(exam: exam)
                                    //.fixedSize()
    //                                .frame(minHeight: 200)
                                    .tabItem {
                                        Text(exam.wrappedDate, formatter: Formatters.dateFormat)
                                    }
                                    .tag(exam.wrappedId)
                            }

                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        //.fixedSize()
                        .frame(height: 250)
                        }
                        
                    }
                    
                    
                    
                    if !self.lastPeriodExams.isEmpty {
                    
                        SummarySection(labelName: "Heart Rate", labelIcon: "heart.fill", color: UIColor.systemRed, selectedRange: self.selectedRange, values: [Int(self.means.heartrate)], units: ["BPM"])
                        
                        SummarySection(labelName: "Exam type", labelIcon: "lungs.fill", color: .systemIndigo, selectedRange: self.selectedRange, values: [Int(means.examType.0), Int(means.examType.1)], units: ["resting", "stress"])

                        SummarySection(labelName: "Interval", labelIcon: "metronome.fill", color: .systemPink, selectedRange: self.selectedRange, values: [Int(1000 * self.means.interval)], units: ["ms"])

                        SummarySection(labelName: "IQR", labelIcon: "metronome.fill", color: .systemGreen, selectedRange: self.selectedRange, values: [Int(1000 * self.means.iqr)], units: ["ms"])

//                        SummarySection(labelName: "Exam type", labelIcon: "lungs.fill", color: .systemIndigo, selectedRange: self.selectedRange, values: [Int(means.examType.0), Int(means.examType.1)], units: [makeString(floor(100 * (Double(means.examType.0) / Double(lastPeriodExams.count))), "%"), makeString(ceil(100 * (Double(means.examType.1) / Double(lastPeriodExams.count))), "%")])
//
                        
                        
                        
                        
                        
                    }
                }
            } else {
                Button {
                    switchTab = .exam
                } label: {
                    Text("Make first examination")
                }

            }
            
        }
        .navigationTitle("Summary")
        .onAppear(perform: updateValues)
    }
    
    
    func updateValues() {
        if profile.examArray.count > 0 {
            self.filteredExams = Array(profile.examArray[0...min(profile.examArray.count - 1, 2)])
        }
        print("filtered ", self.filteredExams)
        
        let range = ClosedRange<Date>(uncheckedBounds: (lower: Calendar.current.date(byAdding: .day, value: -self.selectPeriod.rawValue, to: Date())!, upper: Date()))
//        self.selectedRange.loweBound = Calendar.current.date(byAdding: .day, value: -self.selectPeriod.rawValue, to: Date())!
//        self.selectedRange.upperBound = Date()
//
        self.lastPeriodExams = Array(profile.examArray.filter({ Exam in
            
            return range.contains(Exam.wrappedDate)
            
        }))
        
        print("lastPeriod", self.lastPeriodExams)
        
        self.means = calculateMeans()
        self.selectedRange = SelectedRange(lowerBound: Calendar.current.date(byAdding: .day, value: -self.selectPeriod.rawValue, to: Date())!, upperBound: Date())
    }
    
    init(profile: Profile, switchTab: Binding<Tab>, selectedPeriod: TimePeriod = .week) {
        
        self.profile = profile
        self._switchTab = switchTab
        self.selectPeriod = selectedPeriod
        
//        self.selectedRange.lowerBound = Calendar.current.date(byAdding: .day, value: -self.selectPeriod.rawValue, to: Date())!
//        self.selectedRange.upperBound = Date()
    }
}

//struct HistoryOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryOverview(profile: Profile()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
