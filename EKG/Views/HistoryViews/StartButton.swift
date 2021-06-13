////
////  MeanBmpGraph.swift
////  EKG
////
////  Created by Krzysztof Chodkiewicz on 23/05/2021.
////
//
//import SwiftUI
//
//struct StartButton: View {
//
//    //@State var color: Color = .green
//    @State var isProcessing: Bool = false
//    @Binding var isExam: Bool
//
//    @State var trimStart: CGFloat = 0.0
//    @State var trimEnd: CGFloat = 0.5
//
//    @State var progress = 0.0
//
//    var action: () -> Void
//
//    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
//
//    func spin(_ enable: Bool) -> Animation {
//        if enable {
//            return Animation.spring(dampingFraction: 0.7).delay(0.5)
//                .repeatForever(autoreverses: false)
//        } else {
//            return Animation.spring(dampingFraction: 0.7)
//        }
//    }
//
//    var body: some View {
//
//        Button {
//            withAnimation {
//                if !isProcessing {
//                    isExam.toggle()
//
//                    if isExam {
//                        self.isProcessing.toggle()
//
////                        let cancel = DispatchQueue.global(qos: .userInteractive).schedule(after: DispatchQueue.SchedulerTimeType(.now()), interval: DispatchQueue.SchedulerTimeType.Stride(.milliseconds(10)), tolerance: .zero) {
//
////                            print(trimStart)
////
////                        }
//
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
////                            self.isProcessing.toggle()
////                        }
//                        action()
//                        self.isProcessing.toggle()
//                    }
//
//
//                }
//
//            }
//        } label: {
//            ZStack {
//
//                RoundedRectangle(cornerRadius: isProcessing ? CGFloat(220.0 / 2.0) : CGFloat(10.0), style: .continuous)
//                    .fill(isExam ? Color.red : Color.green)
//                    .frame(width: CGFloat(isProcessing ? 55 : 220), height: 55)
//                    .padding(10)
//                    .animation(.spring(dampingFraction: 0.7))
//                    .hoverEffect(isProcessing ? .highlight : .automatic)
//
////                RoundedRectangle(cornerRadius: isProcessing ? CGFloat(228.0 / 2.0) : CGFloat(10.0), style: .continuous)
////                    .trim(from: isProcessing ? trimStart : 0.0, to: isProcessing ? trimEnd : 1.0)
////                    .stroke(isExam ? Color.red : Color.green, lineWidth: 3.0)
////                    .frame(width: CGFloat(isProcessing ? 63 : 228), height: 63)
////
////                    //.rotationEffect(Angle.degrees(isProcessing ? 1180 : 0))
////                    //.animation(isProcessing ? animation : nil)
////                    //.animation(.spring(dampingFraction: 0.7))
////                    .onReceive(timer, perform: { _ in
////
////                        self.progress = Double((Int(self.progress * 100) + 10) % 50) / 100
////                        self.trimStart = CGFloat(progress)
////
////                        self.trimEnd = CGFloat(progress + 0.5)
////                        print("PROGRESS ------------------------------ ", self.progress)
////                    })
////                    .animation(.linear)
//
//
//
//                ProgressView(value: isProcessing ? self.progress : 1.0, total: 1.0)
//                    .progressViewStyle(GaugeProgressStyle(strokeColor: isExam ? .red : .green, frameWidth: isProcessing ? 63 : 228))
//                    .onReceive(timer, perform: { _ in
//
//                        self.progress = Double((Int(self.progress * 100) + 10) % 50) / 100
//
//                        print("PROGRESS ------------------------------ ", self.progress)
//                    })
//                    .animation(.linear)
//
//
//
//                    Text(isExam ? (isProcessing ? "Preparing" : "Stop") : "Start")
//                    .frame(width: 63, height: 63)
//                    .foregroundColor(Color.white)
//
////                    .scaleEffect(isExam ? 0.8 : 1.0)
////                    .animation(.spring(dampingFraction: 0.5))
//                //.clipShape(Circle())
//
//            }
//
//        }
//        .buttonStyle(PlainButtonStyle())
//
//
//
//
//    }
//}
//
////struct MeanBmpGraph_Previews: PreviewProvider {
////    static var previews: some View {
////        StartButton(action: {
////            print("hello")
////        })
////    }
////}
