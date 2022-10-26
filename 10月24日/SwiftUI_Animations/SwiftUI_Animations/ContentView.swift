//
//  ContentView.swift
//  SwiftUI_Animations
//
//  Created by ming on 2022/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .partOne
    
    enum Tab {
        case partOne
        case partTwo
        case partThree
    }
    
    var body: some View {
        TabView(selection: $selection) {
            PartOneGroup()
                .tabItem {
                    Label("Part One", systemImage: "star")
                }
                .tag(Tab.partOne)
            
            PartTwoGroup()
                .tabItem {
                    Label("Part Two", systemImage: "list.bullet")
                }
                .tag(Tab.partTwo)
            
            PartThreeGroup()
                .tabItem {
                    Label("Part Three", systemImage: "note")
                }
                .tag(Tab.partThree)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
