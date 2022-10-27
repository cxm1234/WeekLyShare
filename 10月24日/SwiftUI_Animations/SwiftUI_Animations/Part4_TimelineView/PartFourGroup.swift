//
//  PartFourGroup.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/27.
//

import SwiftUI

struct PartFourGroup: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Example17()
                } label: {
                    Text("Example 17")
                }
                
                NavigationLink {
                    Example18()
                } label: {
                    Text("Example 18")
                }
                
                NavigationLink {
                    Example19()
                } label: {
                    Text("Example 19")
                }
                
                NavigationLink {
                    Example20()
                } label: {
                    Text("Example 20")
                }
            }
        }
    }
}

struct PartFourGroup_Previews: PreviewProvider {
    static var previews: some View {
        PartFourGroup()
    }
}
