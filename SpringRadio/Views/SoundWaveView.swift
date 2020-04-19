//
//  SoundWaveView.swift
//  SpringRadio
//
//  Created by jack on 2020/4/19.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct SoundWaveView: UIViewRepresentable {
    
    var spectra: [[Float]]
    var barWidth: CGFloat
    var space: CGFloat
    var leftColor:[CGColor]
    var rightColor:[CGColor]
    
    
    func makeUIView(context: Context) -> SpectrumView {
        return SpectrumView()
    }
    
    func updateUIView(_ uiView: SpectrumView, context: Context) {
        uiView.barWidth = barWidth
        uiView.space = space
        guard spectra.count > 0 else {
            return
        }
        uiView.spectra = spectra
        
    }
}

//struct SoundWaveView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SoundWaveView(spectra: [[0.0],[0.0]], barWidth: 3.0, space: 0)
//    }
//}
