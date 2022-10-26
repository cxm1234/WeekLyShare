//
//  SkewedOffset.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct SkewedOffset: GeometryEffect {
    var offset: CGFloat
    var pct: CGFloat
    let goingRight: Bool
    
    init(offset: CGFloat, pct: CGFloat, goingRight: Bool) {
        self.offset = offset
        self.pct = pct
        self.goingRight = goingRight
    }
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { return AnimatablePair<CGFloat, CGFloat>(offset, pct)}
        set {
            offset = newValue.first
            pct = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        var skew: CGFloat
        
        if pct < 0.2 {
            skew = (pct * 5) * 0.5 * (goingRight ? -1 : 1)
        } else if pct > 0.8 {
            skew = ((1 - pct) * 5) * 0.5 * (goingRight ? -1 : 1)
        } else {
            skew = 0.5 * (goingRight ? -1 : 1)
        }
        
        return ProjectionTransform(CGAffineTransform(1, 0, skew, 1, offset, 0))
    }
    
}
