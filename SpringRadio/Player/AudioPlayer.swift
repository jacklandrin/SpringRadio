//
//  AudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//

import AVFoundation
import AVKit
import MediaPlayer

class PlayerManager:NSObject, AVPlayerItemMetadataOutputPushDelegate {
    
    static let shared = PlayerManager()
    var audioPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    var currentAudioStation:Playable? = nil
    
    
    private override init() {
        super.init()
        self.setupRemoteCommandCenter()
    }
    
    // MARK: - Private
        
    // MARK: - Player
    
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
        self.playerItem = AVPlayerItem(url: url)
        self.audioPlayer = AVPlayer(playerItem: playerItem)
        self.audioPlayer?.play()
        setupNowPlaying()
        
        
        
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: .main)
        self.playerItem?.add(metadataOutput)

    }
    
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentAudioStation?.radioItem.title
        let image = UIImage(named: self.currentAudioStation?.radioItem.imageName ?? "AppIcon")!
        let newImage = image.resized(to:  CGSize(width: 50, height: 50), scale: 3)
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 50, height: 50), requestHandler: { _ in
            newImage
        })

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            var station = self.currentAudioStation
            station?.isPlaying = true
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.currentAudioStation?.isPlaying = false
            return .success
        }
        commandCenter.nextTrackCommand.isEnabled = self.currentAudioStation?.itemStatesInList == .Last ? false : true
        commandCenter.nextTrackCommand.addTarget { event in
            self.currentAudioStation?.nextStation()
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = self.currentAudioStation?.itemStatesInList == .First ? false : true
        commandCenter.previousTrackCommand.addTarget { event in
            self.currentAudioStation?.previousStation()
            return .success
            
        }
    }
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        guard let item = groups.first?.items.first, let title = item.value(forKeyPath: "value") as? String else {
            let currentStationTitle = self.currentAudioStation?.radioItem.title ?? ""
            self.currentAudioStation?.streamTitle = currentStationTitle
            return
        }
        self.currentAudioStation?.streamTitle = title
    }
    
}


extension AVPlayer {
    
    func stop() {
        self.seek(to: CMTime.zero)
        self.pause()
    }
}
