//
//  Example4.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct Example4: View {
    @State private var sides: Double = 4
    @State private var duration: Double = 1.0
    @State private var scale: Double = 1.0
    
    var body: some View {
        VStack {
            Example4PolyShape(sides: sides,scale: scale)
                .stroke(Color.purple, lineWidth: 5)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
                
            Text("\(Int(sides)) sides, \(String(format: "%.2f", scale as Double)) scale")
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.sides = 1.0
                    self.scale = 1.0
                }
                
                MyButton(label: "3") {
                    self.sides = 3.0
                    self.scale = 0.7
                }
                
                MyButton(label: "7") {
                    self.sides = 7.0
                    self.scale = 0.4
                }
                
                MyButton(label: "30") {
                    self.sides = 30.0
                    self.scale = 1.0
                }
            }
        }.navigationBarTitle("Example 4").padding(.bottom, 50)
    }
}

struct Example4_Previews: PreviewProvider {
    static var previews: some View {
        Example4()
    }
}
