//
//  Example17.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/27.
//

import SwiftUI

/*
惊了？为什么左边的 emoji 会变，而另一个总是悲伤？事实证明， SubView 没有接收到任何变化的参数，这意味着它没有依赖关系。SwiftUI 没有理由重新计算视图的主体。2021 年 WWDC 的一个精彩演讲是 Demystify SwiftUI。它解释了视图标识、生命周期和依赖关系。所有这些主题对于理解时间线为何如此运行都非常重要。
*/

struct Example17: View {
    
    var body: some View {
        ManyFaces()
    }
}

struct ManyFaces: View {
    static let emoji = ["😀", "😬", "😄", "🙂", "😗", "🤓", "😏", "😕", "😟", "😎", "😜", "😍", "🤪"]
    
    var body: some View {
//        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
//            Text("\(timeline.date)")
//        }
        
        
        TimelineView(.periodic(from: .now, by: 0.2)) { timeline in

            HStack(spacing: 120) {
                let randomEmoji = ManyFaces.emoji.randomElement() ?? ""
                Text(randomEmoji)
                    .font(.largeTitle)
                    .scaleEffect(4.0)
//                SubView(date: timeline.date)
                SubView()
            }
        }
    }
    
    struct SubView: View {
        
//        let date: Date
        
        var body: some View {
            let randomEmoji = ManyFaces.emoji.randomElement() ?? ""
            
            Text(randomEmoji)
                .font(.largeTitle)
                .scaleEffect(4.0)
        }
    }
}

struct Example17_Previews: PreviewProvider {
    static var previews: some View {
        Example17()
    }
}
