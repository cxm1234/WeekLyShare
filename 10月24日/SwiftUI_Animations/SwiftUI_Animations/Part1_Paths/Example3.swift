//
//  Example3.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

/// 动画是如何工作的
/*
在所有SwiftUI动画的背后，有一个名为 Animatable 的协议。我们将在后面讨论细节，但主要是，它拥有一个计算属性，其类型遵守 VectorArithmetic 协议。这使得框架可以随意地插值。

当给一个视图制作动画时，SwiftUI 实际上是多次重新生成该视图，并且每次都修改动画参数。这样，它就会从原点值渐渐走向最终值。

假设我们为一个视图的不透明度创建一个线性动画。我们打算从 0.3 到 0.8。该框架将多次重新生成视图，以小幅度的增量来改变不透明度。由于不透明度是以 Double表示的，而且Double 遵守 VectorArithmetic` 协议，SwiftUI 可以插值出所需的不透明度值。在框架代码的某个地方，可能有一个类似的算法。
 */
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

struct Example3PolyShape: Shape {
    var sides: Int
    private var sidesAsDouble: Double
    
    var animatableData: Double {
        get { return sidesAsDouble }
        set { sidesAsDouble = newValue }
    }
    
    init(sides: Int) {
        self.sides = sides
        self.sidesAsDouble = Double(sides)
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = Double(sidesAsDouble) != Double(Int(sidesAsDouble)) ? 1 : 0
        
        for i in 0..<Int(sidesAsDouble) + extra {
            let angle = (Double(i) * (360.0 / Double(sidesAsDouble))) * Double.pi / 180
            
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt)
            } else {
                path.addLine(to: pt)
            }
        }
        
        path.closeSubpath()
        
        return path
    }
    
}


struct Example3_Previews: PreviewProvider {
    static var previews: some View {
        Example3()
    }
}
