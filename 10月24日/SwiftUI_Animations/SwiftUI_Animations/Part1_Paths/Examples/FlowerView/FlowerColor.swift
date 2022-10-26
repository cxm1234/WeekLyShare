//
//  FlowerColor.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct FlowerColor: View {
    let petals: Int
    let length: Double
    let color: Color
    
    @State private var animate = false
    
    var body: some View {
        let petalWidth1 = Angle(degrees: 2)
        let petalWidth2 = Angle(degrees: 360 / Double(self.petals)) * 2
        
        return GeometryReader { proxy in
            ForEach(0..<self.petals) { i in
                PetalShape(
                    angle: Angle(degrees: Double(i) * 360 / Double(self.petals)),
                    arc: self.animate ? petalWidth1 : petalWidth2,
                    length: self.animate ? self.length : self.length * 0.9
                ).fill(
                    RadialGradient(
                        gradient: Gradient(
                            colors: [self.color.opacity(0.2), self.color]
                        ),
                        center: UnitPoint(x: 0.5, y: 0.5),
                        startRadius: 0.1 * min(proxy.size.width, proxy.size.height) / 2.0,
                        endRadius: min(proxy.size.width, proxy.size.height) / 2.0)
                )
            }
        }.onAppear {
            withAnimation(Animation.easeOut(duration: 1.5).repeatForever()) {
                self.animate = true
            }
        }
        
    }
}

struct FlowerColor_Previews: PreviewProvider {
    static var previews: some View {
        FlowerColor(petals: 3, length: 10, color: .blue)
    }
}
