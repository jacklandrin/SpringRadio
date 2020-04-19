//
//  AudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//
import Foundation
import MediaPlayer

protocol AudioPlayer {
    var currentAudioStation:Playable? {get set}
    var updateSpectrum:(([[Float]]) -> Void)? { get set }
    var analyzer:RealtimeAnalyzer {get set}
    func play<T:Playable>(stream item: T?)
    func stop()
}

extension AudioPlayer {
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
            var station = self.currentAudioStation
            station?.isPlaying = false
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
}



