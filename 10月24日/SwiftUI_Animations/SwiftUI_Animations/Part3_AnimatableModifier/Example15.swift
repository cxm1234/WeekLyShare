//
//  Example15.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct Example15: View {
    @State private var flag = false
    @State private var number: Double = 21
    
    var body: some View {
        VStack {
            Color.clear
            
            Slider(value: $number, in: 0...99)
            Text("Number = \(number)")
            
            HStack(spacing: 10) {
                MyButton(label: "17", font: .headline) {
                    withAnimation(Animation.interpolatingSpring(mass: 0.1, stiffness: 1, damping: 0.4, initialVelocity: 0.8)) {
                        self.number = 17
                    }
                }
                
                MyButton(label: "87", font: .headline) {
                    withAnimation(Animation.interpolatingSpring(mass: 0.1, stiffness: 1, damping: 0.4, initialVelocity: 0.8)) {
                        self.number = 23
                    }
                }
                
                MyButton(label: "87", font: .headline) {
                    withAnimation(Animation.interpolatingSpring(mass: 0.1, stiffness: 1, damping: 0.4, initialVelocity: 0.8)) {
                        self.number = 87
                    }
                }
            }
            
        }
        .overlay(MovingCounter(number: number))
        .navigationBarTitle("Exampler 13")
        
    }
}

struct MovingCounter: View {
    let number: Double
    
    var body: some View {
        Text("00")
            .modifier(MovingCounterModifier(number: number))
    }
    
    struct MovingCounterModifier: AnimatableModifier {
        @State private var height: CGFloat = 0

        var number: Double
        
        var animatableData: Double {
            get { number }
            set { number = newValue }
        }
        
        func body(content: Content) -> some View {
            let n = self.number + 1
            
            let tOffset: CGFloat = getOffsetForTensDigit(n)
            let uOffset: CGFloat = getOffsetForUnitDigit(n)

            let u = [n - 2, n - 1, n + 0, n + 1, n + 2].map { getUnitDigit($0) }
            let x = getTensDigit(n)
            var t = [abs(x - 2), abs(x - 1), abs(x + 0), abs(x + 1), abs(x + 2)]
            t = t.map { getUnitDigit(Double($0)) }
            
            let font = Font.custom("Menlo", size: 34).bold()
            
            return HStack(alignment: .top, spacing: 0) {
                VStack {
                    Text("\(t[0])").font(font)
                    Text("\(t[1])").font(font)
                    Text("\(t[2])").font(font)
                    Text("\(t[3])").font(font)
                    Text("\(t[4])").font(font)
                }.foregroundColor(.green).modifier(ShiftEffect(pct: tOffset))
                
                VStack {
                    Text("\(u[0])").font(font)
                    Text("\(u[1])").font(font)
                    Text("\(u[2])").font(font)
                    Text("\(u[3])").font(font)
                    Text("\(u[4])").font(font)
                }.foregroundColor(.green).modifier(ShiftEffect(pct: uOffset))
            }
            .clipShape(ClipShape())
            .overlay(BackShape().stroke(lineWidth: 5).foregroundColor(Color.blue)) // border
            .background(BackShape().fill(Color.black)) // background
        }
        
        func getUnitDigit(_ number: Double) -> Int {
            return abs(Int(number) - ((Int(number) / 10) * 10))
        }
        
        func getTensDigit(_ number: Double) -> Int {
            return abs(Int(number) / 10)
        }
        
        func getOffsetForUnitDigit(_ number: Double) -> CGFloat {
            return 1 - CGFloat(number - Double(Int(number)))
        }
        
        func getOffsetForTensDigit(_ number: Double) -> CGFloat {
            if getUnitDigit(number) == 0 {
                return 1 - CGFloat(number - Double(Int(number)))
            } else {
                return 0
            }
        }

    }
    
    struct BackShape: Shape {
        func path(in rect: CGRect) -> Path {
            let r = rect
            let h = (r.height / 5.0 + 30.0)
            var p = Path()
            
            let cr = CGRect(x: (rect.width - 80)/2, y: (r.height - h) / 2.0, width: 80, height: h)
            p.addRoundedRect(in: cr, cornerSize: CGSize(width: 5.0, height: 5.0))
            
            return p
        }
    }
    
    struct ClipShape: Shape {
        func path(in rect: CGRect) -> Path {
            let r = rect
            let h = (r.height / 5.0 + 30.0)
            var p = Path()
            
            let cr = CGRect(x: 0, y: (r.height - h) / 2.0, width: r.width, height: h)
            p.addRoundedRect(in: cr, cornerSize: CGSize(width: 5.0, height: 5.0))
            
            return p
        }
    }
    
    struct ShiftEffect: GeometryEffect {
        var pct: CGFloat = 1.0
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            return .init(.init(translationX: 0, y: (size.height / 5.0) * pct))
        }
    }
}

struct Example15_Previews: PreviewProvider {
    static var previews: some View {
        Example15()
    }
}
