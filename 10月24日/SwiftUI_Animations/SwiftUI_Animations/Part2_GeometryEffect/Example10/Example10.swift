//
//  Example10.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct Example10: View {
    @State private var flag = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                InfinityShape()
                    .stroke(.purple, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [7, 7], dashPhase: 0))
                    .foregroundColor(.blue)
                    .frame(width: proxy.size.width, height: 300)
                
            
                Image(systemName: "airplane")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 50, height: 50)
                    .offset(x: -25, y: -25)
                    .modifier(
                        FollowEffect(
                            pct: self.flag ? 1: 0,
                            path: InfinityShape.createInfinityPath(
                                in: CGRect(
                                    x: 0,
                                    y: 0,
                                    width: proxy.size.width,
                                    height: 300
                                )
                            ),
                            rotate: true
                        )
                    )
                    .onAppear {
                        withAnimation(
                            .linear(
                                duration: 4.0
                            )
                            .repeatForever(
                                autoreverses: false
                            )
                        ) {
                            self.flag.toggle()
                        }
                    }
                
            }.frame(alignment: .topLeading)
            
        }
        .padding(20)
        .navigationBarTitle("Example 10")
    }
}

struct Example10_Previews: PreviewProvider {
    static var previews: some View {
        Example10()
    }
}
