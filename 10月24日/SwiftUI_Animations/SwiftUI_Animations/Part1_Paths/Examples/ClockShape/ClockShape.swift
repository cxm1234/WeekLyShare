//
//  ClockShape.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

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
