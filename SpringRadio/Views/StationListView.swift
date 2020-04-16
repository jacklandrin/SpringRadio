//
//  ContentView.swift
//  SpringRadio
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import AVFoundation

struct StationListView: View {
    
    @State var currentStationIndex : Int = 0
    @EnvironmentObject var items : RadioItems
    
    var body: some View {
        GeometryReader { g in
            self.makeNavigationView(g: g)
        }
    }
    
    func makeNavigationView(g:GeometryProxy) -> some View {
       screenWidth = g.frame(in: .global).width
       screenHeight = g.frame(in: .global).height
       let view = NavigationView {
            ZStack{
                List {
                    ForEach (self.items.values.indices) { i in
                        StationCell().environmentObject(self.items.values[i]).frame(height: 44)
                        .onTapGesture {
                            let item = self.items.values[i]
                            item.isPlaying = !item.isPlaying
                            if item.isPlaying && self.currentStationIndex != i {
                                self.currentStationIndex = i
                            }
                        }
                    }
                    Spacer(minLength: listSpacer())
                }
                
                VStack {
                    Spacer()
                    MiniPlayerControl(previousStation: {
                        guard self.currentStationIndex > 0 else {
                            return
                        }
                        self.currentStationIndex -= 1
                        self.items.values[self.currentStationIndex].isPlaying = true
                    }, nextStation: {
                        guard self.currentStationIndex < self.items.values.count - 1 else  {
                            return
                        }
                        self.currentStationIndex += 1
                        self.items.values[self.currentStationIndex].isPlaying = true
                    })
                        .environmentObject(self.items.values[self.currentStationIndex])
                        .frame(height:TrapezoidParameters.trapezoidHeight)
                }.edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle(Text("Stations"))
        }.navigationViewStyle(StackNavigationViewStyle())
        return view
    }
    
    func listSpacer() -> CGFloat {
        self.items.values[self.currentStationIndex].isPlaying ? TrapezoidParameters.trapezoidHeight - 32 : 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StationListView().environmentObject(RadioItems())
    }
}
