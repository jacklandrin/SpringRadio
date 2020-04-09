//
//  AudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//

import AVFoundation
import AVKit

class PlayerManager:NSObject, AVPlayerItemMetadataOutputPushDelegate {
    
    static let shared = PlayerManager()
    var audioPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    var currentAudioStion: RadioStationPlayable? = nil
    
    
    private override init() {}
    
    // MARK: - Private
        
    // MARK: - Player
    
    func play(stream item: RadioStationPlayable?) {
        
        guard let stream = item?.radioItem.streamURL, let url = URL(string: stream.rawValue) else {
            fatalError("=========== Can`t play stream ===========")
        }
        
        if (self.currentAudioStion != nil) && self.currentAudioStion !== item {
            self.currentAudioStion?.isPlaying = false
            self.currentAudioStion?.streamTitle = defaultStreamTitle
        }
        
        self.currentAudioStion = item
        
        self.audioPlayer?.stop()
        self.playerItem = AVPlayerItem(url: url)
        self.audioPlayer = AVPlayer(playerItem: playerItem)
        self.audioPlayer?.play()
        
        
        
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: .main)
        self.playerItem?.add(metadataOutput)
        
    }
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        guard let item = groups.first?.items.first, let title = item.value(forKeyPath: "value") as? String else {
            self.currentAudioStion?.streamTitle = self.currentAudioStion?.radioItem.title ?? ""
            return
        }
        self.currentAudioStion?.streamTitle = title
    }
    
}


extension AVPlayer {
    
    func stop() {
        self.seek(to: CMTime.zero)
        self.pause()
    }
}
