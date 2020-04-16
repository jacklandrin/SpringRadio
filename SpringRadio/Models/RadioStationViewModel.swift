//
//  RadioStationViewModel.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct RadioItem {
    
    var title: String
    var streamURL: RadioURL
    var imageName: String
}

let defaultStreamTitle = "Loading..."


class RadioStationPlayable: Playable, Identifiable{
    let id = UUID()
    @Published var isPlaying: Bool = false
    {
        didSet {
            if isPlaying {
                PlayerManager.shared.play(stream: self)
                if self.themeColor == .yellow {
                     self.seizeColorInImage(imageName: self.radioItem.imageName, defaultColor: .yellow)
                }
                print("play")
            }  else {
                PlayerManager.shared.audioPlayer?.stop()
                print("stop")
            }
            objectWillChange.send()
        }
    }
    
    var radioItem : RadioItem
    init(radioItem:RadioItem) {
        self.radioItem = radioItem
        
    }
    
    var streamTitle: String = defaultStreamTitle
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    var themeColor:Color = .yellow
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    var sideColor:Color = .white
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    
    private func seizeColorInImage(imageName:String, defaultColor: Color) {
        self.themeColor = defaultColor
        DispatchQueue.global(qos: .userInitiated).async {
            let originalImage = UIImage(named: imageName)
            let smallImage = originalImage?.resized(to: CGSize(width: 100, height: 100))
            let kMeans = KMeansClusterer()
            let points = smallImage?.getPixels().map({KMeansClusterer.Point(from: $0)})
            let clusters = kMeans.cluster(points: points!, into: 3).sorted(by: {$0.points.count > $1.points.count})
            let colors = clusters.map(({$0.center.toUIColor()}))
            guard let mainColor = colors.first else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.themeColor = Color(mainColor)
                self.sideColor = Color(self.makeTextColor(from: mainColor))
            }
           
        }
        
        
    }
    
    private func makeTextColor(from color : UIColor) -> UIColor {
        return color.hslColor.shiftHue(by: 0.4).shiftSaturation(by: -0.4).shiftBrightness(by: 0.5).uiColor
    }
    
    
    let objectWillChange = ObservableObjectPublisher()//PassthroughSubject<RadioStationPlayable, Never>()
}


extension RadioStationPlayable {
   
    static func radionStationExample() -> RadioStationPlayable {
        let radioStation = RadioStationPlayable(radioItem: RadioItem(title: "Dance UK Radio", streamURL: .danceUK, imageName: "danceUK"))
        radioStation.isPlaying = true
        return radioStation
    }
}

protocol Playable : ObservableObject {
    var isPlaying : Bool { get set }
}

enum RadioURL: String {
    case danceUK = "http://uk2.internet-radio.com:8024/listen.pls"
    case boxUK = "http://51.75.170.46:6191/stream"
    case rrDrumAndBass = "http://air2.radiorecord.ru:9003/drumhits_320"
    case dfmPopDance = "https://dfm-popdance.hostingradio.ru/popdance96.aacp"
    case dfmRussianDance = "https://dfm-dfmrusdance.hostingradio.ru/dfmrusdance96.aacp"
    case rrRussianGold = "http://air2.radiorecord.ru:9003/russiangold_320"
    case dnbMyRadio = "http://relay.myradio.ua:8000/DrumAndBass128.mp3"
    case countryRadio = "https://live.leanstream.co/CKRYFM"
    case americasCountry = "https://ais-sa2.cdnstream1.com/1976_128.mp3"
    case batYamRadioRus = "http://891fm.streamgates.net/891Fm"
    case rrRussianHits = "http://air2.radiorecord.ru:9003/russianhits_320"
    case rrEDMHits = "http://air2.radiorecord.ru:9003/edmhits_320"
    case rrFutureHouse = "http://air2.radiorecord.ru:9003/fut_320"
    case veniceClassicItalia = "http://174.36.206.197:8000/listen.pls?sid=1"
    case austinBluesRadio = "http://ca10.rcast.net:8036/listen.pls?sid=1"
    case soundFusion = "http://uk6.internet-radio.com:8346/listen.pls"
}

class RadioItems : ObservableObject {
   @Published var values: [RadioStationPlayable] =  [
            RadioStationPlayable(radioItem: RadioItem(title: "Dance UK Radio", streamURL: .danceUK, imageName: "danceUK")),
            RadioStationPlayable(radioItem: RadioItem(title: "Box UK Radio", streamURL: .boxUK, imageName: "boxUK")),
            RadioStationPlayable(radioItem: RadioItem(title: "Sound Fusion Radio", streamURL: .soundFusion, imageName: "soundFusion")),
            RadioStationPlayable(radioItem: RadioItem(title: "Country 105 FM", streamURL: .countryRadio, imageName: "countryRadio")),
            RadioStationPlayable(radioItem: RadioItem(title: "Americas Country", streamURL: .americasCountry, imageName: "americasCountry")),
            RadioStationPlayable(radioItem: RadioItem(title: "Venice Classic Radio Italia", streamURL: .veniceClassicItalia, imageName: "veniceClassic")),
            RadioStationPlayable(radioItem: RadioItem(title: "Austin Blues Radio", streamURL: .austinBluesRadio, imageName: "austinBlues")),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Record Drum'n'Bass", streamURL: .rrDrumAndBass, imageName: "radioRecord")),
            RadioStationPlayable(radioItem: RadioItem(title: "DFM Pop Dance", streamURL: .dfmPopDance, imageName: "dfmPopDance")),
            RadioStationPlayable(radioItem: RadioItem(title: "DFM Russian Dance", streamURL: .dfmRussianDance, imageName: "russianDance")),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records Russian Hits", streamURL: .rrRussianHits, imageName: "rrRussianHits")),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records EDM Hits", streamURL: .rrEDMHits, imageName: "rrEdmHits")),
            RadioStationPlayable(radioItem: RadioItem(title: "Bat Yam 89.1 FM", streamURL: .batYamRadioRus, imageName: "batYamRussian")),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records Russian Gold", streamURL: .rrRussianGold, imageName: "rrRussianGold")),
            RadioStationPlayable(radioItem: RadioItem(title: "DnB My Radio", streamURL: .dnbMyRadio, imageName: "dnbMyRadio")),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Record Future House", streamURL: .rrFutureHouse, imageName: "rrFutureHouse"))
        ]
    
    
}


