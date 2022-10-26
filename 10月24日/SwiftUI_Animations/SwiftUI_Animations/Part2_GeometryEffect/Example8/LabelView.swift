//
//  LabelView.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct LabelView: View {
    let text: String
    var offset: CGFloat
    var pct: CGFloat
    let backgroundColor: Color
    
    var body: some View {
        Text("The SwiftUI Lab")
            .font(.headline)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(backgroundColor))
            .foregroundColor(.black)
            .modifier(SkewedOffset(offset: offset, pct: pct, goingRight: offset > 0))
    }
}

struct LabelView_Previews: PreviewProvider {
    static var previews: some View {
        LabelView(text: "The SwiftUI Lab", offset: 120, pct: 1, backgroundColor: .red)
    }
}
