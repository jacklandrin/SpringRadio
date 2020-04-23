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
    @State var imageAngle:Double = 0
    @State var isAnimating: Bool = false
    @State var offsetY: CGFloat = TrapezoidParameters.trapezoidHeight
    
    var previousStation : () -> Void
    var nextStation : () -> Void
    var pressImage : () -> Void
    
    var body: some View {
        GeometryReader{ g in
            self.makeMainStack(g: g)
                .onAppear {
                self.isAnimating = true
                }
        }
       .navigationBarHidden(self.currentItem.pushed)
       .navigationBarBackButtonHidden(self.currentItem.pushed)
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
        if !self.currentItem.pushed {
            VStack {
                Spacer()
                BluredSoundWave().opacity(self.currentItem.isPlaying ? 0.8 : 0)
            }.edgesIgnoringSafeArea(.all)
        }
            
            VStack {
                Spacer(minLength: TrapezoidParameters.trapezoidHeight * 0.3)
                HStack{
                    Button(action:pressImage, label: {
                        Image(self.currentItem.radioItem.imageName).renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                            .resizable()
                            .frame( width:60,height:60)
                            .scaledToFill()
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                            .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false))
                    })
                    .buttonStyle(MagnifyButtonStyle())
                    .padding(.leading ,25)
                        .scaleEffect((self.tappedImage || self.currentItem.pushed) ? 1.2 : 1.0)
                   
                        
                    Spacer()
                    VStack {
                        Text(titleDisplay()).foregroundColor(self.currentItem.sideColor).lineLimit(2)
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
       }.offset(y:offsetY)
        .animation(.spring())
        .onReceive(self.currentItem.objectWillChange) { _ in
            if self.currentItem.isPlaying {
                self.offsetY = 0.0
            }
        }
        return view
    }
    
    func titleDisplay() -> String {
        self.currentItem.isPlaying ?  currentItem.streamTitle : self.currentItem.radioItem.title
    }
    
    func controlPlay() {
        self.currentItem.isPlaying = !self.currentItem.isPlaying
    }
    
    
    func tapPreviousButton() {
        self.previousStation()
    }
    
    func tapNextButton() {
        self.nextStation()
    }
    
}


struct MagnifyButtonStyle:ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 1.2 : 1.0)
    }
}

struct MiniPlayerControl_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayerControl(previousStation: {}, nextStation: {}, pressImage: {}).environmentObject(RadioStationPlayable.radionStationExample()).previewLayout(.fixed(width: UIScreen.main.bounds.width, height: TrapezoidParameters.trapezoidHeight))
    }
}

