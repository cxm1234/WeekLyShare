//
//  PartThreeGroup.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct PartThreeGroup: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Example12()
                } label: {
                    Text("Example 12")
                }
                
                NavigationLink {
                    Example13()
                } label: {
                    Text("Example 13")
                }
                
                NavigationLink {
                    Example14()
                } label: {
                    Text("Example 14")
                }
                
                NavigationLink {
                    Example15()
                } label: {
                    Text("Example 15")
                }
                
                NavigationLink {
                    Example16()
                } label: {
                    Text("Example 16")
                }
            }
        }
    }
}

struct PartThreeGroup_Previews: PreviewProvider {
    static var previews: some View {
        PartThreeGroup()
    }
}
