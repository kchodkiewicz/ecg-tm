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

struct HistoryOverview: View {
    
    @ObservedObject var profile: Profile
    @Binding var switchTab: Tab
    @State var selectPeriod: TimePeriod = .week
    
    @State var lastPeriodExams: [Exam] = []
    //@State var filteredExams: [Exam] = []
    @State var selectedRange: SelectedRange = SelectedRange()
    @State var means: MeanStats = MeanStats()
    
    @State var showPicker: Bool = false
    
    struct MeanStats {
        //TODO: create graphs
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
        GeometryReader { proxy in
            
            
            if !self.lastPeriodExams.isEmpty {
                
                //                List {
                //
                //                    Section(header:
                //                                Text("Average results")
                //                    ) {
                //                        SummarySection(labelName: "Heart Rate", labelIcon: "heart.fill", color: .systemPink, selectedRange: self.selectedRange, values: [Int(self.means.heartrate)], units: ["BPM"])
                //                    }
                //
                //                    Section {
                //                        SummarySection(labelName: "Exam type", labelIcon: "lungs.fill", color: .systemIndigo, selectedRange: self.selectedRange, values: [Int(means.examType.0), Int(means.examType.1)], units: ["resting", "stress"])
                //                    }
                //
                //                    Section {
                //                        SummarySection(labelName: "Interval", labelIcon: "metronome.fill", color: .systemRed, selectedRange: self.selectedRange, values: [Int(1000 * self.means.interval)], units: ["ms"])
                //                    }
                //
                //                    Section {
                //                        SummarySection(labelName: "IQR", labelIcon: "metronome.fill", color: .systemGreen, selectedRange: self.selectedRange, values: [Int(1000 * self.means.iqr)], units: ["ms"])
                //                    }
                //
                //                }
                //                .listStyle(InsetGroupedListStyle())
                
                
                VStack {
                    
                    List {
                        EmptyView()
                    }.listStyle(InsetGroupedListStyle())
                    .frame(height: 0)
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            //if showPicker {
                                Picker("Time period", selection: self.$selectPeriod) {
                                    ForEach(TimePeriod.allCases, id: \.self) { type in
                                        Text(type.displayName)
                                        
                                    }
                                }
                                
                                .padding(.horizontal)
                                .pickerStyle(SegmentedPickerStyle())
                                
                                .onChange(of: self.selectPeriod) { _ in
                                    withAnimation {
                                        updateValues()
                                    }
                                }
                                .transition (
                                    .asymmetric (
                                        insertion: .move(edge: .bottom),
                                        removal:
                                            .move(edge: .top)
                                    )
                                )
                            //}
                            
                            GroupBox(label: HStack {
                                Label("Heart Rate", systemImage: "heart.fill")
                                    .foregroundColor(Color(.systemPink))
                                Spacer()
                                
                                Text("\(Formatters.withoutYear(date: self.selectedRange.lowerBound)) - \(Formatters.withoutYear(date: self.selectedRange.upperBound))")
                                    .font(.body)
                                    .foregroundColor(Color(.secondaryLabel))
                            }) {
                                HStack {
                                    Text("\(Int(self.means.heartrate))")
                                        .font(.system(.largeTitle, design: .rounded))
                                        .bold()
                                    Text("BPM")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                            }.padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .id(1)
                            
                            GroupBox(label: HStack {
                                Label("Exam type", systemImage: "lungs.fill")
                                    .foregroundColor(Color(.systemIndigo))
                                Spacer()
                                
                                Text("\(Formatters.withoutYear(date: self.selectedRange.lowerBound)) - \(Formatters.withoutYear(date: self.selectedRange.upperBound))")
                                    .font(.body)
                                    .foregroundColor(Color(.secondaryLabel))
                            }) {
                                
                                HStack {
                                    
                                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                                        Text("\(Int(means.examType.0))")
                                            .font(.system(.largeTitle, design: .rounded))
                                            .bold()
                                        Text("resting")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        
                                    }
                                    
                                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                                        Text("\(Int(means.examType.1))")
                                            .font(.system(.largeTitle, design: .rounded))
                                            .bold()
                                        Text("stress")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        
                                    }
                                    
                                    Spacer()
                                    
                                }
                                
                            }.padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                            
                            GroupBox(label: HStack {
                                Label("Interval", systemImage: "metronome.fill")
                                    .foregroundColor(Color(.systemRed))
                                Spacer()
                                
                                Text("\(Formatters.withoutYear(date: self.selectedRange.lowerBound)) - \(Formatters.withoutYear(date: self.selectedRange.upperBound))")
                                    .font(.body)
                                    .foregroundColor(Color(.secondaryLabel))
                            }) {
                                HStack {
                                    Text("\(Int(1000 * self.means.interval))")
                                        .font(.system(.largeTitle, design: .rounded))
                                        .bold()
                                    Text("ms")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                            }.padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                            
                            GroupBox(label: HStack {
                                Label("IQR", systemImage: "metronome.fill")
                                    .foregroundColor(Color(.systemGreen))
                                Spacer()
                                
                                Text("\(Formatters.withoutYear(date: self.selectedRange.lowerBound)) - \(Formatters.withoutYear(date: self.selectedRange.upperBound))")
                                    .font(.body)
                                    .foregroundColor(Color(.secondaryLabel))
                            }) {
                                HStack {
                                    Text("\(Int(1000 * self.means.iqr))")
                                        .font(.system(.largeTitle, design: .rounded))
                                        .bold()
                                    Text("ms")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                            }.padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                            
                            
                        }.groupBoxStyle(ColoredGroupBoxStyle(backgroundColor: UIColor.secondarySystemGroupedBackground))
//                        .gesture(
//                            DragGesture()
//                                .onChanged({ offset in
//                                    if offset.translation.height > 0 {
//                                        withAnimation {
//                                            print("Scroll down")
//                                            self.showPicker = true
//                                        }
//                                    } else {
//                                        withAnimation {
//                                            print("Scroll up")
//                                            self.showPicker = false
//                                        }
//
//                                    }
//                                })
//                        )
                        
                    }
                    
                }
                //.padding(.top)
                
                //                .toolbar(content: {
                //
                //                    ToolbarItemGroup(placement: .principal) {
                //                        Picker("Time period", selection: self.$selectPeriod) {
                //                            ForEach(TimePeriod.allCases, id: \.self) { type in
                //                                Text(type.displayName)
                //
                //                            }
                //                        }
                //                        //.background(Color(.systemGroupedBackground))
                //                        //.padding(.horizontal)
                //                        //.frame(height: proxy.safeAreaInsets.top)
                //                        .pickerStyle(SegmentedPickerStyle())
                //                        .onChange(of: self.selectPeriod) { _ in
                //                            withAnimation {
                //                                updateValues()
                //                            }
                //                        }
                //                    }
                //                })
                
            } else {
                Button {
                    switchTab = .exam
                } label: {
                    Text("Make first examination")
                }
                
            }
        }
        .navigationTitle("Summary")
        
        //.navigationViewStyle(StackNavigationViewStyle())
        .background(Color(.systemGroupedBackground))
        
        .onAppear(perform: {
            updateValues()
            UINavigationBar.appearance().backgroundColor = .clear
            
        })
        
        //        .onDisappear(perform: {
        //            UINavigationBar.appearance().backgroundColor = .systemBackground
        //        })
        .onChange(of: switchTab) { _ in
            if switchTab == .overview {
                updateValues()
            }
        }
        
    }
    
    
    func updateValues() {
        
        //        if profile.examArray.count > 0 {
        //            self.filteredExams = Array(profile.examArray[0...min(profile.examArray.count - 1, 2)])
        //        }
        //print("filtered ", self.filteredExams)
        
        let range = ClosedRange<Date>(uncheckedBounds: (lower: Calendar.current.date(byAdding: .day, value: -self.selectPeriod.rawValue, to: Date())!, upper: Date()))
        
        
        self.lastPeriodExams = Array(profile.examArray.filter({ Exam in
            
            return range.contains(Exam.wrappedDate)
            
        }))
        
        //print("lastPeriod", self.lastPeriodExams)
        
        self.means = calculateMeans()
        self.selectedRange = SelectedRange(lowerBound: Calendar.current.date(byAdding: .day, value: -self.selectPeriod.rawValue, to: Date())!, upperBound: Date())
        
    }
    
    init(profile: Profile, switchTab: Binding<Tab>) {
        
        self.profile = profile
        self._switchTab = switchTab
        updateValues()
        
    }
}

//struct HistoryOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryOverview(profile: Profile()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
