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
    @ObservedObject var soundWave:SoundWaveModel = SoundWaveModel()
//    @State var imageEdge:CGFloat = screenWidth * 0.5
    let floatTitleFontSize: CGFloat = 85.0
    let streamTitleFontSize: CGFloat = 50.0
    let maxImageEdge:CGFloat = 300.0
    let leftColors = [UIColor(red: 235/255, green: 2/255, blue: 119/255, alpha: 0.8).cgColor,
                      UIColor(red: 253/255, green: 229/255, blue: 241/255, alpha: 0.7).cgColor]
    let rightColors = [UIColor(red: 39/255, green: 133/255, blue: 195/255, alpha: 0.8).cgColor,
                       UIColor(red: 253/255, green: 229/255, blue: 241/255, alpha: 0.7).cgColor]
    
    var floatTitleText: some View {
        Text(self.currentItem.radioItem.title)
        .font(Font.system(size: floatTitleFontSize))
        .bold()
        .foregroundColor(self.currentItem.sideColor)
        .lineLimit(1)
            .offset(x: self.floatText.titleX, y: self.floatText.titleY)
            .position(x:self.floatText.orientation == .horizontal ? screenWidth : screenHeight,y:self.floatText.orientation == .horizontal ? 300 : 260)
            .rotationEffect(self.floatText.orientation == .horizontal ? .degrees(0) : .degrees(90))
            .brightness(0.3)
        .scaledToFit()
    }
    
    var floatStreamText: some View {
        Text(self.currentItem.streamTitle)
        .font(Font.system(size: streamTitleFontSize))
        .bold()
        .foregroundColor(self.currentItem.sideColor)
        .lineLimit(1)
            .offset(x: self.floatText.streamTitleX, y: self.floatText.streamTitleY)
        .position(x:self.floatText.orientation == .horizontal ? screenWidth : screenHeight,y:self.floatText.orientation == .horizontal ? 20 : 100)
        .rotationEffect(self.floatText.orientation == .horizontal ? .degrees(0) : .degrees(90))
            .brightness(0.3)
        .scaledToFit()
    }
    
    
    var body: some View {
        self.currentItem.themeColor.brightness(0.05).edgesIgnoringSafeArea(.all).overlay(
            GeometryReader{ g in
                self.makeMainStack(g)
            }
            
            
        ).onAppear{
            self.floatText.startAnimation()
        }.onReceive(self.floatText.timer) { n in
            print("timer \(n)")
            self.floatText.startAnimation()
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
                    .padding(.bottom, 150)
                Spacer()
                SoundWaveView(spectra: self.soundWave.spectra, barWidth: self.soundWave.barWidth, space: self.soundWave.space, leftColor: leftColors, rightColor: rightColors).frame(width: screenWidth, height:150).blur(radius: 7.5)
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
            }.edgesIgnoringSafeArea(.all)
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
        StationDetail().environmentObject(RadioStationPlayable.radionStationExample())
    }
}
