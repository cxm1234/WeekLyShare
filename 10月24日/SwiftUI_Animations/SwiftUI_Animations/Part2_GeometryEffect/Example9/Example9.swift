//
//  Example9.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct Example9: View {
    var body: some View {
        HStack {
            Spacer()
            RotatingCard()
            Spacer()
        }.background(.black).navigationBarTitle("Example 9")
    }
}

struct Example9_Previews: PreviewProvider {
    static var previews: some View {
        Example9()
    }
}
