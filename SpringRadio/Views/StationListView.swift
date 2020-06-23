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
    
    @EnvironmentObject var items : RadioItems
    @State var detailOffsetX : CGFloat = 0.0
    @State var isShowDetail:Bool = false
    {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                withAnimation(Animation.easeOut(duration: 0.6)) {
                    self.currentItem().backButtonOffsetY = self.isShowDetail ? 0 : -backButtonPositionY
                }
            })
            self.currentItem().pushed = self.isShowDetail
            self.detailOffsetX = self.detailShouldOffsetX()
        }
    }
    @State var isDraggingDetail: Bool = false
    
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
                    ForEach (self.items.values.indices, id: \.self) { i in
                        StationCell().environmentObject(self.items.values[i]).frame(height: 44)
                        .onTapGesture {
                            let item = self.items.values[i]
                            item.isPlaying = !item.isPlaying
                            if item.isPlaying && self.items.currentStationIndex != i {
                                self.items.currentStationIndex = i
                            }
                        }
                    }
                    Spacer(minLength: listSpacer())
                }
                
                VStack {
                    Spacer()
                    MiniPlayerControl(previousStation: self.items.previousStation, nextStation: self.items.nextStation, pressImage: showDetail)
                        .environmentObject(currentItem())
                        .frame(height:TrapezoidParameters.trapezoidHeight)
                        .offset(y:controlOffsetY())
                }.edgesIgnoringSafeArea(.all)
//                if isShowDetail {
                    StationDetail(backAction:hideDetail)
                                       .environmentObject(currentItem())
                                       .shadow(radius: 2)
//                                        .transition(.move(edge: .trailing))
                                       .offset(x: detailShowControl())
                                       .opacity(detailOpacity())
//                                       .rotation3DEffect(detailAngle(), axis: (x: 0, y: screenWidth, z: 0))
                                       .gesture(DragGesture()
                                           .onChanged{ value in
                                               self.isDraggingDetail = true
                                               let offsetX = value.translation.width
                                               self.detailOffsetX = offsetX
                                       }
                                           .onEnded{ value in
                                               let offsetX = value.translation.width
                                               self.isDraggingDetail = false
                                               self.isShowDetail = offsetX < screenWidth / 2
                                               self.currentItem().pushed = self.isShowDetail
                                       })
//                }
               
            }
            .navigationBarTitle(Text("Stations"))
        }.navigationViewStyle(StackNavigationViewStyle())
        return view
    }
    
    func listSpacer() -> CGFloat {
        self.items.values[self.items.currentStationIndex].isPlaying ? TrapezoidParameters.trapezoidHeight - 32 : 0
    }
    
    func showDetail() {
        withAnimation{
            self.isShowDetail = true
        }
    }
    
    func hideDetail() {
        withAnimation{
            self.isShowDetail = false
        }
    }
    
    func detailShowControl() -> CGFloat {
        
        if self.isDraggingDetail {
            return self.detailOffsetX
        } else {
            return detailShouldOffsetX()
        }
        
    }
    
    func detailShouldOffsetX() -> CGFloat {
        self.isShowDetail ? 0.0 : screenWidth
    }
    
    func detailAngle() -> Angle {
        return .degrees(Double( (screenWidth - self.detailOffsetX) / screenWidth) * 90.0 )
    }
    
    func detailOpacity() -> Double {
        Double(1.0 - (self.detailOffsetX / screenWidth))
    }
    
    func currentItem() -> RadioStationPlayable {
        return self.items.values[self.items.currentStationIndex]
    }
    
    func controlOffsetY() -> CGFloat {
        if #available(iOS 14.0, *) {
            return 20
        } else {
            return 0
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StationListView().environmentObject(RadioItems())
    }
}


