////
////  CardioStatistics.swift
////  EKG
////
////  Created by Krzysztof Chodkiewicz on 26/05/2021.
////
//
//import Foundation
//import Combine
//
//class CardioStatistics: ObservableObject {
//
//    var profile: Profile
//    @Published var weeklyMean: ([Double], [Date], [Int]) = ([],[],[])
//    @Published var weeklyMax: Double = 0
//    @Published var monthlyMean: ([Double], [Date], [Int]) = ([],[],[])
//    @Published var monthlyMax: Double = 0
//
//    init(profile: Profile) {
//        self.profile = profile
//
//        calculateMean()
//    }
//
//    public func recalculateMean(exam: Exam) {
//
//        // if first exam ever
//        guard self.monthlyMean.2.count > 0 else {
//
//            // add date = Date(), count = 1, mean = 1 (normalized), max = heartRate (mean == heartRate)
//            self.weeklyMean.0.append(Double(exam.heartRate))
//            self.weeklyMean.1.append(exam.wrappedDate)
//            self.weeklyMean.2.append(1)
//            self.weeklyMax = Double(exam.heartRate)
//
//            // add date = Date(), count = 1, mean = 1 (normalized), max = heartRate (mean == heartRate)
//            self.monthlyMean.0.append(Double(exam.heartRate))
//            self.monthlyMean.1.append(exam.wrappedDate)
//            self.monthlyMean.2.append(1)
//            self.monthlyMax = Double(exam.heartRate)
//
//            return
//        }
//
//        // if exam is first in a day
//        guard self.monthlyMean.2.last! != 0 else {
//
//            // make place for new measurement by removing the oldest value
//            self.weeklyMean.0.removeFirst()
//            self.weeklyMean.1.removeFirst()
//            self.weeklyMean.2.removeFirst()
//            // add mean (mean == heartRate) and normalize with weeklyMax
//            self.weeklyMean.0.append(Double(exam.heartRate) / self.weeklyMax)
//            self.weeklyMean.1.append(exam.wrappedDate)
//            // increment count
//            self.weeklyMean.2.append(self.weeklyMean.2.last! + 1)
//
//            // make place for new measurement by removing the oldest value
//            self.monthlyMean.0.removeFirst()
//            self.monthlyMean.1.removeFirst()
//            self.monthlyMean.2.removeFirst()
//            // add mean (mean == heartRate) and normalize with weeklyMax
//            self.monthlyMean.0.append(Double(exam.heartRate) / self.monthlyMax)
//            self.monthlyMean.1.append(exam.wrappedDate)
//            // increment count
//            self.monthlyMean.2.append(self.monthlyMean.2.last! + 1)
//
//            return
//        }
//
//        // else
//        // pick last mean
//        // newSum = (mean * max) * count + heartRate (unwrap sum from mean and count and add new value)
//        let newSum = (self.monthlyMean.0.last! * self.monthlyMax) * Double(self.monthlyMean.2.last!) + Double(exam.heartRate)
//        // newMean = newSum / (count + 1)
//        let newMean = newSum / Double(self.monthlyMean.2.last! + 1)
//
//
//        // normalize (if newMean greater then current max -> recalculate everything)
//        guard newMean < self.monthlyMax else {
//            calculateMean()
//            return
//        }
//        let normalized = newMean / self.monthlyMax
//        // replace last mean and increment count
//        self.monthlyMean.0[self.monthlyMean.0.count - 1] = normalized
//        self.monthlyMean.2[self.monthlyMean.0.count - 1] += 1
//        self.weeklyMean.0[self.weeklyMean.0.count - 1] = normalized
//        self.weeklyMean.2[self.weeklyMean.0.count - 1] += 1
//
//    }
//
//    public func calculateMean() {
//
//        var heartRates: [Double] = []
//        var dates: [Date] = []
//        var counts: [Int] = []
//        for i in 0...30 {
//
//            let evaluatedDate = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
//
//            let examsOfADay = self.profile.examArray.filter { Exam in
//                Calendar.current.isDate(evaluatedDate, inSameDayAs: Exam.wrappedDate)
//            }
//
//            var sum: Int64 = 0
//
//            for exam in examsOfADay {
//                sum += exam.heartRate
//            }
//            if examsOfADay.count > 0 {
//
//                let mean: Double = Double(sum) / Double(examsOfADay.count)
//
//                heartRates.append(mean)
//                dates.append(evaluatedDate)
//            } else {
//                heartRates.append(0.0)
//                dates.append(evaluatedDate)
//            }
//            counts.append(examsOfADay.count)
//        }
//
//        guard let max = heartRates.max() else { return }
//        self.monthlyMax = max
//
//        self.monthlyMean = (heartRates.reversed(), dates.reversed(), counts.reversed())
//
//        let weeklyHeartRates = Array(heartRates[0...6])
//        guard let weeklyMax = weeklyHeartRates.max() else { return }
//        self.weeklyMax = weeklyMax
//
//        self.weeklyMean = (weeklyHeartRates.reversed(), Array(dates[0...6].reversed()), Array(counts[0...6].reversed()))
//
//    }
//
//
//
//    public func getDay(date: Date) -> String {
//
//        let current = Calendar.current
//        let day = current.dateComponents([.day], from: date)
//
//        return String(day.day!)
//    }
//
//
//
//}
