//
//  ContentView.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct ContentView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
