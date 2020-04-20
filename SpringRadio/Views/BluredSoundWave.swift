//
//  BluredSoundWave.swift
//  SpringRadio
//
//  Created by jack on 2020/4/20.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

let leftColors = [UIColor(red: 235/255, green: 2/255, blue: 119/255, alpha: 0.8).cgColor,
                  UIColor(red: 253/255, green: 229/255, blue: 241/255, alpha: 0.7).cgColor]
let rightColors = [UIColor(red: 39/255, green: 133/255, blue: 195/255, alpha: 0.8).cgColor,
                   UIColor(red: 253/255, green: 229/255, blue: 241/255, alpha: 0.7).cgColor]

struct BluredSoundWave: View {
    @ObservedObject var soundWave:SoundWaveModel = SoundWaveModel()
    var body: some View {
        SoundWaveView(spectra: self.soundWave.spectra, barWidth: self.soundWave.barWidth, space: self.soundWave.space, leftColor: leftColors, rightColor: rightColors).frame(width: screenWidth, height:150).blur(radius: 7.5)
    }
}

struct BluredSoundWave_Previews: PreviewProvider {
    static var previews: some View {
        BluredSoundWave()
    }
}
