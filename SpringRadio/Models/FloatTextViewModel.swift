//
//  FloatTextViewModel.swift
//  SpringRadio
//
//  Created by jack on 2020/4/8.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum FloatTextOrientation: Int {
    case vertical = 0, horizontal
}

let floatAnimationDuration = 10.0
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class FloatTextViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()//PassthroughSubject<FloatTextViewModel, Never>()
   
    let timer = Timer.publish(every: floatAnimationDuration, on: .main, in: .common).autoconnect()
    
    let animation = Animation.linear(duration: floatAnimationDuration)
    
    
    var orientation : FloatTextOrientation = .horizontal
    {
        willSet {
            objectWillChange.send()
        }
    }
    
//    var currentItem:RadioStationPlayable
//    
//    init(radioStation: RadioStationPlayable) {
//        self.currentItem = radioStation
//    }
    
    private var _titleWidth :CGFloat = 300
    
    var titleWidth: CGFloat
    {
        set {
            if _titleWidth != newValue {
                _titleWidth = newValue
                print("titleWidth:\(_titleWidth)")
            }
            
        }
        
        get {
            return _titleWidth
        }
    }
    
    private var _streamTitleWidth : CGFloat = -300
    
    var streamTitleWidth : CGFloat
    {
        set {
                if _streamTitleWidth != newValue {
                    _streamTitleWidth = newValue
                    print("streamTitleWidth:\(_streamTitleWidth)")
                    self.changeOrientation(orientation: self.orientation)
                    }
        }
                
        get {
            return _streamTitleWidth
        }
    }
    
    
    var titleX: CGFloat = screenWidth
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    var titleY: CGFloat = 0.0
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    var streamTitleX: CGFloat = 0.0
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    var streamTitleY: CGFloat = 0.0
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    func startAnimation() {
        self.changeOrientation(orientation: FloatTextOrientation(rawValue: Int.random(in: 0...1)) ?? .horizontal)
    }

    func changeOrientation(orientation:FloatTextOrientation) {
        
        if self.orientation != orientation {
            self.orientation = orientation
            switch orientation {
            case .horizontal:
                let distanceTitleX = screenWidth + self.titleWidth
                let distanceStreamTitleX = screenWidth + self.streamTitleWidth
                self.titleX = -distanceTitleX
                self.streamTitleX = distanceStreamTitleX
            case .vertical:
                let distanceTitleX = screenHeight + self.titleWidth
                let distanceStreamTitleX = screenHeight + self.streamTitleWidth
                self.titleX = -distanceTitleX
                self.streamTitleX = distanceStreamTitleX
            }
        }
        
        
        
        switch orientation {
        case .horizontal:
            self.titleY = CGFloat(Float.random(in: -240.0...240.0))
            self.streamTitleY = CGFloat(Float.random(in: -240.0...240.0))
            let distanceTitleX = screenWidth + self.titleWidth
            let distanceStreamTitleX = screenWidth + self.streamTitleWidth
            
            withAnimation(Animation.linear(duration: floatAnimationDuration)) {
                print("old title x:\(self.titleX)")
                if self.titleX != -distanceTitleX {
                    self.titleX = -distanceTitleX
                } else {
                    self.titleX = distanceTitleX
                }
                
                if self.streamTitleX != distanceStreamTitleX {
                    self.streamTitleX = distanceStreamTitleX
                } else {
                    self.streamTitleX = -distanceStreamTitleX
                }
                
                print("new title x:\(self.titleX)")
            }
            break
            
        case .vertical:
            self.titleY = CGFloat(Float.random(in: -50.0...50.0))
            self.streamTitleY = CGFloat(Float.random(in: -50.0...50.0))
            let distanceTitleX = screenHeight + self.titleWidth
            let distanceStreamTitleX = screenHeight + self.streamTitleWidth
            withAnimation(Animation.linear(duration: floatAnimationDuration)) {
                print("old title x:\(self.titleX)")
                if self.titleX != -distanceTitleX {
                    self.titleX = -distanceTitleX
                } else {
                    self.titleX = distanceTitleX
                }
                
                if self.streamTitleX != distanceStreamTitleX {
                    self.streamTitleX = distanceStreamTitleX
                } else {
                    self.streamTitleX = -distanceStreamTitleX
                }
                
                print("new title x:\(self.titleX)")
            }
            
            
            break
        }
        
    }
    
}
