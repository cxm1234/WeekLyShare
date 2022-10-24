//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

struct Example2: View {
    @State private var half = false
    @State private var dim = false
    
    var body: some View {
        Image("tower")
            .scaleEffect(half ? 0.5 : 1.0)
            .opacity(dim ? 0.5 : 1.0)
            .onTapGesture {
                self.half.toggle()
                
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.dim.toggle()
                }
        }
    }
}

PlaygroundPage.current.setLiveView(Example2())
//: [Next](@next)
