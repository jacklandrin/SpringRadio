//
//  JLASAudioPlayer+Streamer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/19.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import AVFoundation

extension JLASAudioPlayer : StreamingDelegate {
    
    func streamer(_ streamer: Streaming, failedDownloadWithError error: Error, forURL url: URL) {
        self.audioPlayer.stop()
    }
    
    func streamer(_ streamer: Streaming, updatedDownloadProgress progress: Float, forURL url: URL) {
        
    }
    
    func streamer(_ streamer: Streaming, changedState state: StreamingState) {
        
    }
    
    func streamer(_ streamer: Streaming, updatedCurrentTime currentTime: TimeInterval) {
        
    }
    
    func streamer(_ streamer: Streaming, updatedDuration duration: TimeInterval) {
        
    }
    
    func streamer(_ streamer: Streaming, updateBuffer: AVAudioPCMBuffer) {
        let buffer = updateBuffer
        queue.async { [weak self] in
            let spectra = self?.analyzer.analyse(with: buffer)
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.updateSpectrum?(spectra!)
            }
        }
        
    }
    
    
}
