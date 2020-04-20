//
//  JLASAudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/19.
//  Copyright © 2020 jack. All rights reserved.
//

import AVFoundation
import AVKit
import MediaPlayer

let bufferSize = 512

class JLASAudioPlayer: NSObject, AudioPlayer, AVPlayerItemMetadataOutputPushDelegate {
    let queue = DispatchQueue(label: "com.springRadio.spectrum")
    lazy var audioPlayer: Streamer = {
        let audioPlayer = Streamer()
        audioPlayer.delegate = self
        return audioPlayer
    }()
    var currentAudioStation: Playable?
    var updateSpectrum: (([[Float]]) -> Void)?
    var analyzer:RealtimeAnalyzer = RealtimeAnalyzer(fftSize: bufferSize)
    private var avplayer: AVPlayer = AVPlayer()
    
    override init() {
        super.init()
        self.setupRemoteCommandCenter()
    }
    
    func play<T>(stream item: T?) where T : Playable {
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
        
        
        setAVPlayer(url: url)
        audioPlayer.url = url
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.audioPlayer.play()
        }
        
       
        self.setupNowPlaying()
    }
    
    func setAVPlayer(url:URL)  {
        let playerItem = AVPlayerItem(url: url)
        self.avplayer = AVPlayer(playerItem: playerItem)
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: .main)
        playerItem.add(metadataOutput)
        self.avplayer.play()
        self.avplayer.isMuted = true
    }
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        guard let item = groups.first?.items.first, let title = item.value(forKeyPath: "value") as? String else {
            let currentStationTitle = self.currentAudioStation?.radioItem.title ?? ""
            self.currentAudioStation?.streamTitle = currentStationTitle
            return
        }
        self.currentAudioStation?.streamTitle = title
    }
    
    func stop() {
        audioPlayer.stop()
        avplayer.stop()
    }
    
    
}
