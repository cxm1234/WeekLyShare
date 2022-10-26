//
//  Example5.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct Example5: View {
    @State private var sides: Double = 4
    @State private var scale: Double = 1.0
    
    var body: some View {
        VStack {
            Example5PolyShape(sides: sides, scale: scale)
                .stroke(Color.pink, lineWidth: (sides < 3) ? 10 : (sides < 7 ? 5 : 2))
                .padding(20)
                .animation(.easeInOut(duration: 3.0))
                .layoutPriority(1)
            
            Text("\(Int(sides)) sides, \(String(format: "%.2f", scale as Double)) scale")
            
            Slider(value: $sides, in: 0...30)
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.sides = 1.0
                    self.scale = 1.0
                }
                
                MyButton(label: "3") {
                    self.sides = 3.0
                    self.scale = 1.0
                }
                
                MyButton(label: "7") {
                    self.sides = 7.0
                    self.scale = 1.0
                }
                
                MyButton(label: "30") {
                    self.sides = 30.0
                    self.scale = 1.0
                }
                
            }
        }
    }
}

struct Example5_Previews: PreviewProvider {
    static var previews: some View {
        Example5()
    }
}
