//
//  Example19.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/27.
//

import SwiftUI

struct Example19: View {
    var body: some View {
        TimelineView(.cyclic(timeOffsets: [0.2, 0.2, 0.4])) { timeline in
            Heart(date: timeline.date)
        }
    }
}

struct Heart: View {
    @State private var phase = 0
    let scales: [CGFloat] = [1.0, 1.6, 2.0]
    
    let date: Date
    
    var body: some View {
        HStack {
            Text("❤️")
                .font(.largeTitle)
                .scaleEffect(scales[phase])
                .animation(.spring(response: 0.10,
                                   dampingFraction: 0.24,
                                   blendDuration: 0.2),
                           value: phase)
                .onChange(of: date) { _ in
                    advanceAnimationPhase()
                }
                .onAppear {
                    advanceAnimationPhase()
                }

        }
    }
    
    func advanceAnimationPhase() {
        phase = (phase + 1) % scales.count
    }
}

struct CyclicTimelineSchedule: TimelineSchedule {
    let timeOffsets: [TimeInterval]
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> Entries {
        Entries(last: startDate, offsets: timeOffsets)
    }
    
    struct Entries: Sequence, IteratorProtocol {
        var last: Date
        let offsets: [TimeInterval]
        
        var idx: Int = -1
        
        mutating func next() -> Date? {
            idx = (idx + 1) % offsets.count
            
            last = last.addingTimeInterval(offsets[idx])
            
            return last
        }
    }
}

extension TimelineSchedule where Self == CyclicTimelineSchedule {
    static func cyclic(timeOffsets: [TimeInterval]) -> CyclicTimelineSchedule {
            .init(timeOffsets: timeOffsets)
    }
}

struct Example19_Previews: PreviewProvider {
    static var previews: some View {
        Example19()
    }
}
