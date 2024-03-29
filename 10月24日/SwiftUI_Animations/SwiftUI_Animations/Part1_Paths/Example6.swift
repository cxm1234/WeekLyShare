//
//  Example6.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct Example6: View {
    @State private var time: ClockTime = ClockTime(9, 50, 5)
    @State private var duration: Double = 2.0
    
    var body: some View {
        VStack {
            ClockShape(clockTime: time)
                .stroke(Color.blue, lineWidth: 3)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            Text("\(time.asString())")
            
            HStack(spacing: 20) {
                MyButton(
                    label: "9:51:45",
                    font: .footnote,
                    textColor: .black
                ) {
                    self.duration = 2.0
                    self.time = ClockTime(9, 51, 45)
                }
                
                MyButton(
                    label: "9:51:15",
                    font: .footnote,
                    textColor: .black
                ) {
                    self.duration = 2.0
                    self.time = ClockTime(9, 51, 15)
                }
                
                MyButton(
                    label: "9:52:15",
                    font: .footnote,
                    textColor: .black
                ) {
                    self.duration = 2.0
                    self.time = ClockTime(9, 52, 15)
                }
                
                MyButton(
                    label: "10:01:45",
                    font: .caption,
                    textColor: .black
                ) {
                    self.duration = 10.0
                    self.time = ClockTime(10, 01, 45)
                }
            }
        }.navigationBarTitle("Example 6").padding(.bottom, 50)
    }
}

struct ClockShape: Shape {
    var clockTime: ClockTime
    
    var animatableData: ClockTime {
        get { clockTime }
        set { clockTime = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = min(rect.size.width / 2.0, rect.size.height / 2.0)
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        let hHypotenuse = Double(radius) * 0.5 // 时针长度
        let mHypotenuse = Double(radius) * 0.7 // 分针长度
        let sHypotenuse = Double(radius) * 0.9 // 秒针长度
        
        let hAngle: Angle = .degrees(Double(clockTime.hours) / 12 * 360 - 90)
        let mAngle: Angle = .degrees(Double(clockTime.minutes) / 60 * 360 - 90)
        let sAngle: Angle = .degrees(Double(clockTime.seconds) / 60 * 360 - 90)
        
        let hourNeedle = CGPoint(
            x: center.x + CGFloat(cos(hAngle.radians) * hHypotenuse),
            y: center.y + CGFloat(sin(hAngle.radians) * hHypotenuse)
        )
        let minuteNeedle = CGPoint(
            x: center.x + CGFloat(cos(mAngle.radians) * mHypotenuse),
            y: center.y + CGFloat(sin(mAngle.radians) * mHypotenuse)
        )
        let secondNeedle = CGPoint(
            x: center.x + CGFloat(cos(sAngle.radians) * sHypotenuse),
            y: center.y + CGFloat(sin(sAngle.radians) * sHypotenuse)
        )
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: true
        )
        
        path.move(to: center)
        path.addLine(to: hourNeedle)
        path = path.strokedPath(StrokeStyle(lineWidth: 3.0))
        
        path.move(to: center)
        path.addLine(to: minuteNeedle)
        path = path.strokedPath(StrokeStyle(lineWidth: 3.0))
        
        path.move(to: center)
        path.addLine(to: secondNeedle)
        path = path.strokedPath(StrokeStyle(lineWidth: 1.0))
        
        return path
    }
}

struct ClockTime {
    var hours: Int
    var minutes: Int
    var seconds: Double
    
    init(_ h: Int, _ m: Int, _ s: Double) {
        self.hours = h
        self.minutes = m
        self.seconds = s
    }
    
    init(_ seconds: Double) {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) - (h * 3600)) / 60
        let s = seconds - Double((h * 3600) + (m * 60))
        
        self.hours = h
        self.minutes = m
        self.seconds = s
    }
    
    var asSeconds: Double {
        return Double(self.hours * 3600 + self.minutes * 60) + self.seconds
    }
    
    func asString() -> String {
        return String(format: "%2i", self.hours) + ":" + String(format: "%02i",self.minutes) + ":" + String(format: "%02.0f", self.seconds)
    }
    
}

extension ClockTime: VectorArithmetic {
    
    static func -= (lhs: inout ClockTime, rhs: ClockTime) {
        lhs = lhs - rhs
    }
    
    static func - (lhs: ClockTime, rhs: ClockTime) -> ClockTime {
        return ClockTime(lhs.asSeconds - rhs.asSeconds)
    }
    
    static func += (lhs: inout ClockTime, rhs: ClockTime) {
        lhs = lhs + rhs
    }
    
    static func + (lhs: ClockTime, rhs: ClockTime) -> ClockTime {
        return ClockTime(lhs.asSeconds + rhs.asSeconds)
    }
    
    mutating func scale(by rhs: Double) {
        var s = Double(self.asSeconds)
        s.scale(by: rhs)
        
        let ct = ClockTime(s)
        self.hours = ct.hours
        self.minutes = ct.minutes
        self.seconds = ct.seconds
        
    }
    
    var magnitudeSquared: Double {
        return asSeconds * asSeconds
    }
    
    static var zero: ClockTime {
        return ClockTime(0, 0, 0)
    }

}


struct Example6_Previews: PreviewProvider {
    static var previews: some View {
        Example6()
    }
}
