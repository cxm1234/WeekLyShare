//
//  Example3.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct Example3: View {
    @State private var sides: Int = 4
    @State private var duration: Double = 1.0
    
    var body: some View {
        VStack {
            Example3PolyShape(sides: sides)
                .stroke(Color.blue, lineWidth: 3)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            Text("\(Int(sides)) sides").font(.headline)
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.sides = 1
                }
                
                MyButton(label: "3") {
                    self.sides = 3
                }
                
                MyButton(label: "7") {
                    self.sides = 7
                }
                
                MyButton(label: "30") {
                    self.sides = 30
                }
            }.navigationBarTitle("Example 3").padding(.bottom, 50)
        }
        
       
    }
}

struct Example3_Previews: PreviewProvider {
    static var previews: some View {
        Example3()
    }
}
