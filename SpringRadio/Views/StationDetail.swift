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
    @ObservedObject var floatText:FloatTextViewModel = FloatTextViewModel()
    
    var backAction : () -> Void
    
    let floatTitleFontSize: CGFloat = 180.0
    let streamTitleFontSize: CGFloat = 50.0
    let maxImageEdge:CGFloat = 300.0
    
    
    var floatTitleText: some View {
        Text(self.currentItem.radioItem.title)
        .font(Font.system(size: floatTitleFontSize))
        .bold()
        .foregroundColor(self.currentItem.sideColor)
        .lineLimit(1)
            .offset(x: self.floatText.titleX, y: self.floatText.titleY)
            .position(x:floatPositionX(),y:floatTitlePositionY())
            .rotationEffect(floatRotation())
            .brightness(0.3)
            .opacity(0.65)
        .scaledToFit()
    }
    
   
    
    func floatTitlePositionY() -> CGFloat {
        switch self.floatText.orientation {
        case .horizontal:
            return 200.0
        case .vertical:
            return 140.0
        case .positiveTilt:
            return 180.0
        case .negativeTilt:
            return 180.0
        }
    }
    
    
    
    var floatStreamText: some View {
        Text(self.currentItem.streamTitle)
        .font(Font.system(size: streamTitleFontSize))
        .bold()
        .foregroundColor(self.currentItem.sideColor)
        .lineLimit(1)
            .offset(x: self.floatText.streamTitleX, y: self.floatText.streamTitleY)
        .position(x:floatPositionX(),y:0)
        .rotationEffect(floatRotation())
            .brightness(0.3)
            .opacity(0.85)
        .scaledToFit()
    }
    
    
    func floatPositionX() -> CGFloat {
      switch self.floatText.orientation {
           case .horizontal:
               return screenWidth
           case .vertical:
               return screenHeight
           case .positiveTilt:
               return screenWidth * 1.42
           case .negativeTilt:
               return screenWidth * 1.42
       }
    }
    
    func floatRotation() -> Angle {
        switch self.floatText.orientation {
        case .horizontal:
            return .degrees(0)
        case .vertical:
            return .degrees(90)
        case .positiveTilt:
            return .degrees(45)
        case .negativeTilt:
            return .degrees(-45)
        }
    }
    
    
    var backButton: some View {
        Button(action: self.backAction) {
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
        .onReceive(self.floatText.timer) { n in
            if self.currentItem.pushed {
                self.floatText.startAnimation()
            }
        }
        .onReceive(self.currentItem.streamTitleWillChange) { newValue in
            print("streamTitleWillChange:\(newValue)")
            if self.currentItem.pushed {
                self.floatText.startAnimation()
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
            }
            VStack(alignment:.leading){
                GeometryReader { geometry in
                    self.makeFloatTitleText(geometry)
                }

                GeometryReader { geometry in
                    self.makeFloatStreamTitleText(geometry)
                }
                Spacer()
            }.clipped()
            .opacity(0.90)
            backButton
                .position(x:50,y:backButtonPositionY)
                
        }.clipped()
        .edgesIgnoringSafeArea(.all)
        
        return mainStack
    }
    
    func makeFloatTitleText(_ geometry:GeometryProxy) -> some View {
        self.floatText.titleWidth = UILabel.calculationTextWidth(text: self.currentItem.radioItem.title, fontSize: floatTitleFontSize)
        let text = self.floatTitleText.frame(width:self.floatText.titleWidth)
            
        return text
    }
    
    func makeFloatStreamTitleText(_ geometry: GeometryProxy) -> some View {
        self.floatText.streamTitleWidth = UILabel.calculationTextWidth(text: self.currentItem.streamTitle, fontSize: streamTitleFontSize)//geometry.size.width
        return self.floatStreamText.frame(width:self.floatText.streamTitleWidth).brightness(0.05)
    }
    
    func imageEdge() -> CGFloat {
        let edge = screenWidth / 2
        if edge > maxImageEdge{
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
