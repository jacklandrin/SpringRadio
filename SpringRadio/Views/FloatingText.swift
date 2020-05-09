//
//  FloatingText.swift
//  SpringRadio
//
//  Created by jack on 2020/5/8.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct FloatingText:UIViewRepresentable {
    
    var titleStr: String
    var streamTitleStr: String
    var canFloat:Bool
    
    func makeUIView(context: Context) -> FloatingTextView {
        return FloatingTextView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    }
    
    func updateUIView(_ uiView: FloatingTextView, context: Context) {
        uiView.titleStr = titleStr
        uiView.streamTitleStr = streamTitleStr
        uiView.canFloat = canFloat
    }
}
