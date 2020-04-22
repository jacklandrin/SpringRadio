//
//  JLAVAudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/19.
//  Copyright © 2020 jack. All rights reserved.
//

import AVFoundation
import AVKit
import MediaPlayer

class JLAVAudioPlayer: NSObject ,AVPlayerItemMetadataOutputPushDelegate, AudioPlayer {
    
    var audioPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    var currentAudioStation: Playable?
    var analyzer = RealtimeAnalyzer(fftSize: bufferSize)
    
    override init() {
        super.init()
        self.setupRemoteCommandCenter()
    }
    
    func play<T:Playable>(stream item: T?) {
        
        guard let stream = item?.radioItem.streamURL, let url = URL(string: stream.rawValue) else {
            fatalError("=========== Can`t play stream ===========")
        }
        
        if let station = self.currentAudioStation  {
            if station.radioItem.streamURL != item?.radioItem.streamURL {
                self.currentAudioStation?.isPlaying = false
                self.currentAudioStation?.streamTitle = defaultStreamTitle
            }
        }
        
        self.currentAudioStation = item
        
        self.audioPlayer?.stop()
        
        let asset = AVAsset(url: url)
        
        self.playerItem = AVPlayerItem(asset: asset)
        self.audioPlayer = AVPlayer(playerItem: playerItem)
        self.audioPlayer?.play()
        self.setupNowPlaying()
        
        
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: .main)
        self.playerItem?.add(metadataOutput)

    }
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        guard let item = groups.first?.items.first, let title = item.value(forKeyPath: "value") as? String else {
            let currentStationTitle = self.currentAudioStation?.radioItem.title ?? ""
            self.currentAudioStation?.streamTitle = currentStationTitle
            return
        }
        self.currentAudioStation?.streamTitle = title
    }
    
    func stop(){
        self.audioPlayer?.stop()
    }
}

extension AVPlayer {
    func stop() {
        self.seek(to: CMTime.zero)
        self.pause()
    }
}
