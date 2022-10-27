//
//  Example18.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/27.
//

import SwiftUI
/*
 需要注意的是，每次时间线更新，我们的 QuipView 都会刷新两次。也就是说，在时间线更新时一次，然后在之后立即再次，因为通过调用 quips.advance() 导致 quips.sentence 的 @Published 值发生变化并触发视图更新。
 */
struct Example18: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 3.0)) { timeline in
            QuipView(date: timeline.date)
        }
    }
    
    struct QuipView: View {
            @StateObject var quips = QuipDatabase()
            let date: Date
            
            var body: some View {
                Text("_\(quips.sentence)_")
                    .onChange(of: date) { _ in
                        quips.advance()
                    }
            }
        }
}

class QuipDatabase: ObservableObject {
    static var sentences = [
        "There are two types of people, those who can extrapolate from incomplete data",
        "After all is said and done, more is said than done.",
        "Haikus are easy. But sometimes they don't make sense. Refrigerator.",
        "Confidence is the feeling you have before you really understand the problem."
    ]
    
    @Published var sentence: String = QuipDatabase.sentences[0]
    
    var idx = 0
    
    func advance() {
        idx = (idx + 1) % QuipDatabase.sentences.count
        
        sentence = QuipDatabase.sentences[idx]
    }
}

struct Example18_Previews: PreviewProvider {
    static var previews: some View {
        Example18()
    }
}
