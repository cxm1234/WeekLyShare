//
//  Example1.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

/// 隐式动画是你用 .animation() 修饰符指定的那些动画。每当视图上的可动画参数发生变化时，SwiftUI 就会从旧值到新值制作动画。一些可动画的参数包括大小(size)、偏移(offset)、颜色(color)、比例(scale)等。
struct Example1: View {
    @State private var half = false
    @State private var dim = false
    
    var body: some View {
        Image("tower")
            .scaleEffect(half ? 0.5 : 1.0)
            .opacity(dim ? 0.2 : 1.0)
            .animation(.easeInOut(duration: 1.0))
            .onTapGesture {
                self.dim.toggle()
                self.half.toggle()
            }
    }
}

struct Example1_Previews: PreviewProvider {
    static var previews: some View {
        Example1()
    }
}
