//
//  Example8.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct Example8: View {
    @State private var moveIt = false
    
    var body: some View {
        let animation = Animation.easeInOut(duration: 1.0)
        
        return VStack {
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .red)
                .animation(animation)
            
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .orange)
                .animation(animation.delay(0.1))
            
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .yellow)
                .animation(animation.delay(0.2))
            
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .green)
                .animation(animation.delay(0.3))
            
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .red)
                .animation(animation.delay(0.4))
            
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .red)
                .animation(animation.delay(0.5))
            
            LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .red)
                .animation(animation.delay(0.6))
            
            Button(action: { self.moveIt.toggle() }) {
                Text("Animate")
            }.padding(.top, 50)
        }
        .onTapGesture {
            self.moveIt.toggle()
        }
        .navigationBarTitle("Example 8")
    }
}

struct Example8_Previews: PreviewProvider {
    static var previews: some View {
        Example8()
    }
}
