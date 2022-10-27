//
//  PartOneGroup.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/26.
//

import SwiftUI

struct PartOneGroup: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Example1()
                } label: {
                    Text("Example1")
                }
                
                NavigationLink {
                    Example2()
                } label: {
                    Text("Example2")
                }
                
                NavigationLink {
                    Example3()
                } label: {
                    Text("Example3")
                }
                
                NavigationLink {
                    Example4()
                } label: {
                    Text("Example4")
                }
                
                NavigationLink {
                    Example5()
                } label: {
                    Text("Example5")
                }
                
                NavigationLink {
                    Example6()
                } label: {
                    Text("Example6")
                }
                
                NavigationLink {
                    Example7()
                } label: {
                    Text("Example7")
                }
            }
        }
    }
}

struct PartOneGroup_Previews: PreviewProvider {
    static var previews: some View {
        PartOneGroup()
    }
}
