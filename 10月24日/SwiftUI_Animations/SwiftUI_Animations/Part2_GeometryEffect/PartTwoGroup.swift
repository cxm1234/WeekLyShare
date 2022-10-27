//
//  PartTwoGroup.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct PartTwoGroup: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Example8()
                } label: {
                    Text("Example8")
                }
                
                NavigationLink {
                    Example9()
                } label: {
                    Text("Example9")
                }
                
                NavigationLink {
                    Example10()
                } label: {
                    Text("Example10")
                }
                
                NavigationLink {
                    Example11()
                } label: {
                    Text("Example11")
                }
            }
        }
    }
}

struct PartTwoGroup_Previews: PreviewProvider {
    static var previews: some View {
        PartTwoGroup()
    }
}
