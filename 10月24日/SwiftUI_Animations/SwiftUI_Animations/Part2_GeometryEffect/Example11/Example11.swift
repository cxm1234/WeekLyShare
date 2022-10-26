//
//  Example11.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct Example11: View {
    @State private var animate = false
    
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.green)
                .frame(width: 300, height: 50)
                .overlay(ShowSize())
                .modifier(MyEffect(x: animate ? -10 : 10))
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.blue)
                .frame(width: 300, height: 50)
                .overlay(ShowSize())
                .modifier(MyEffect(x: animate ? 10 : -10).ignoredByLayout())
        }.onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                self.animate = true
            }
        }
    }
}

struct MyEffect: GeometryEffect {
    var x: CGFloat = 0
    
    var animatableData: CGFloat {
        get { x }
        set { x = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: x, y: 0))
    }
}

struct ShowSize: View {
    var body: some View {
        GeometryReader { proxy in
            Text("x = \(Int(proxy.frame(in: .global).minX))")
                .foregroundColor(.white)
        }
    }
}

struct Example11_Previews: PreviewProvider {
    static var previews: some View {
        Example11()
    }
}
