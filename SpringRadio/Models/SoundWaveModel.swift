//
//  SoundWaveModel.swift
//  SpringRadio
//
//  Created by jack on 2020/4/19.
//  Copyright © 2020 jack. All rights reserved.
//

import UIKit

class SoundWaveModel: ObservableObject {
    @Published var spectra: [[Float]] = [[Float]]()
    @Published var barWidth:CGFloat = 3.0
    @Published var space:CGFloat = 0.0
    
    init() {
        self.setSpectrum()
        self.setBarWidth()
    }
    
    func setSpectrum(){
        PlayerManager.shared.player.updateSpectrum = {[weak self] s in
            self?.spectra = s
        }
    }
    
    func setBarWidth() {
        let barSpace = screenWidth / CGFloat(PlayerManager.shared.player.analyzer.frequencyBands * 3 - 1)
        self.barWidth = barSpace * 3
    }
}
