//
//  StationDetail.swift
//  SpringRadio
//
//  Created by jack on 2020/4/8.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI


struct StationDetail: View {
    @EnvironmentObject var currentItem:RadioStationPlayable
    @State var canFloat:Bool = false

    var backAction : () -> Void
    let maxImageEdge:CGFloat = 300.0
    
    
    var backButton: some View {
        Button(action: {
            self.canFloat = false
            self.backAction()
        }) {
            Image("backbutton")
                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                .resizable()
            .shadow(radius: 2)
                .opacity(0.8)
                .offset(y: self.currentItem.backButtonOffsetY)
        }.frame(width:150, height: 150)
            .edgesIgnoringSafeArea(.all)
    }
    
    var body: some View {
        self.currentItem.themeColor.brightness(0.05).edgesIgnoringSafeArea(.all).overlay(
            GeometryReader{ g in
                self.makeMainStack(g)
            }
        )
        .onReceive(self.currentItem.pushedWillChange) { newValue in
            print("pushedWillChange:\(newValue)")
            if newValue {
                self.canFloat = true
            }  else {
                self.canFloat = false
            }
        }
    }
    
    
    func makeMainStack(_ g:GeometryProxy) -> some View {
        screenWidth = g.frame(in: .global).width
        screenHeight = g.frame(in: .global).height
        let mainStack = ZStack {
            VStack {
                Spacer()
                Image(self.currentItem.radioItem.imageName)
                    .resizable()
                    .frame(width:imageEdge(), height:imageEdge())
                    .scaledToFit()
                    .shadow(radius: 5)
                Spacer()
                BluredSoundWave()
            }.frame(minWidth:0, maxWidth: .infinity)
                .background(Color.black.opacity(0.1))
            
            
            VStack{
                FloatingText(titleStr: self.currentItem.radioItem.title, streamTitleStr: self.currentItem.streamTitle, canFloat:canFloat)
            }.clipped()
            .opacity(0.90)
            
            backButton
                .position(x:50,y:backButtonPositionY)
                
        }.clipped()
        .edgesIgnoringSafeArea(.all)
        
        return mainStack
    }
    
    func imageEdge() -> CGFloat {
        let edge = screenWidth / 2
        if edge > maxImageEdge {
            return maxImageEdge
        } else {
            return edge
        }
    }
}

struct StationDetail_Previews: PreviewProvider {
    static var previews: some View {
        StationDetail(backAction: {}).environmentObject(RadioStationPlayable.radionStationExample())
    }
}
