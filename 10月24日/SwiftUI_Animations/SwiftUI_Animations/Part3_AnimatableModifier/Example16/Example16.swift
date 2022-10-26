//
//  Example16.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct Example16: View {
    @State private var flag = false
    
    var body: some View {
        VStack {
            Spacer()
            AnimatableColorText(from: UIColor.systemRed, to: UIColor.systemGreen, pct: flag ? 1 : 0) {
                Text("Hola!").font(.largeTitle)
            }
            Spacer()
            Button("Toggle Color") {
                withAnimation(.easeInOut(duration: 2.0)) {
                    self.flag.toggle()
                }
            }
            Spacer()
        }.navigationBarTitle("Example 14")
    }
}

struct AnimatableColorText: View {
    let from: UIColor
    let to: UIColor
    let pct: CGFloat
    let text: () -> Text
    
    var body: some View {
        let textView = text()
        
        return textView.foregroundColor(Color.clear)
            .overlay(Color.clear.modifier(AnimatableColorTextModifier(from: from, to: to, pct: pct, text: textView)))
    }
    
    struct AnimatableColorTextModifier: AnimatableModifier {
        let from: UIColor
        let to: UIColor
        var pct: CGFloat
        let text: Text
        
        var animatableData: CGFloat {
            get { pct }
            set { pct = newValue }
        }

        func body(content: Content) -> some View {
            return text.foregroundColor(colorMixer(c1: from, c2: to, pct: pct))
        }
        
        // This is a very basic implementation of a color interpolation
        // between two values.
        func colorMixer(c1: UIColor, c2: UIColor, pct: CGFloat) -> Color {
            guard let cc1 = c1.cgColor.components else { return Color(c1) }
            guard let cc2 = c2.cgColor.components else { return Color(c1) }
            
            let r = (cc1[0] + (cc2[0] - cc1[0]) * pct)
            let g = (cc1[1] + (cc2[1] - cc1[1]) * pct)
            let b = (cc1[2] + (cc2[2] - cc1[2]) * pct)

            return Color(red: Double(r), green: Double(g), blue: Double(b))
        }

    }
}

struct Example16_Previews: PreviewProvider {
    static var previews: some View {
        Example16()
    }
}
