//
//  MiniPlayerControl.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct MiniPlayerControl: View {
    @EnvironmentObject var currentItem : RadioStationPlayable
    @State var tappedImage = false
    var previousStation : () -> Void
    var nextStation : () -> Void

    
    var body: some View {
        GeometryReader{ g in
            self.makeMainStack(g: g)
        }
    }
    
    func makeMainStack(g: GeometryProxy) -> some View {
       screenWidth = g.frame(in: .global).width
       screenHeight = g.frame(in: .global).height
       let view = ZStack {
            Path { path in
                let width = screenWidth
                let height:CGFloat = TrapezoidParameters.trapezoidHeight
                path.move(to: CGPoint(x: 0, y: 0))
                TrapezoidParameters.points.forEach {
                    path.addLine(to: .init(x: width * $0.x, y: height * $0.y))
                }
            }.fill(self.currentItem.themeColor)
                .opacity(0.95)
                .brightness(0.05)
                .shadow(radius: 0.8)
            
            
            VStack {
                Spacer(minLength: TrapezoidParameters.trapezoidHeight * 0.3)
                HStack{
                    NavigationLink(destination: StationDetail().environmentObject( self.currentItem)
                        .background(self.currentItem.themeColor), isActive:self.$tappedImage.animation()) {
                        Image(self.currentItem.radioItem.imageName).renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original)).resizable()
                            .frame( width:60,height:60)
                            .scaledToFit()
                            .padding(10)
                            .shadow(radius: 3)
                            .scaleEffect(self.tappedImage ? 1.2 : 1.0)
                    }
                   
                        
                    Spacer()
                    VStack {
                        Text(currentItem.streamTitle).foregroundColor(self.currentItem.sideColor).lineLimit(2)
                        HStack{
                            Spacer()
                            Button(action:tapPreviousButton) {
                                Image("previous_button").foregroundColor(self.currentItem.sideColor).opacity(0.9)
                            }
                            Spacer()
                            Button(action:controlPlay) {
                                Image(self.currentItem.isPlaying ? "pause_button" : "play_button").foregroundColor(self.currentItem.sideColor).opacity(0.9)
                                    
                            }
                            Spacer()
                            Button(action:tapNextButton) {
                                Image("next_button").foregroundColor(self.currentItem.sideColor).opacity(0.9)
                            }
                            Spacer()
                        }
                    }
                    Spacer(minLength: 20)
                }
                Spacer()
            }
        }.offset(y:takeUpDownControl()).animation(.spring())
        return view
    }
    
    func controlPlay() {
        self.currentItem.isPlaying = !self.currentItem.isPlaying
    }
    
    func takeUpDownControl() -> CGFloat {
        self.currentItem.isPlaying ? 0.0 : TrapezoidParameters.trapezoidHeight
    }
    
    func tapPreviousButton() {
        self.currentItem.isPlaying = false
        self.previousStation()
    }
    
    func tapNextButton() {
        self.currentItem.isPlaying = false
        self.nextStation()
    }
    
}


struct MiniPlayerControl_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayerControl(previousStation: {}, nextStation: {}).environmentObject(RadioStationPlayable.radionStationExample()).previewLayout(.fixed(width: UIScreen.main.bounds.width, height: TrapezoidParameters.trapezoidHeight))
    }
}

