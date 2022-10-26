//
//  Example7.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct Example7: View {
    var body: some View {
        VStack {
            FlowerView().drawingGroup()
        }.padding(20)
    }
}

struct Example7_Previews: PreviewProvider {
    static var previews: some View {
        Example7()
    }
}
