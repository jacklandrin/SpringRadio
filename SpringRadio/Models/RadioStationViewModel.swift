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

let backButtonPositionY:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 100.0

class RadioStationPlayable: Playable, ObservableObject, Identifiable{

    let id = UUID()
    var isPlaying: Bool = false
    {
        willSet {
            let currentThread = Thread.current
            if newValue {
                PlayerManager.shared.player.play(stream: self)
                if self.themeColor == .yellow {
                     self.seizeColorInImage(imageName: self.radioItem.imageName, defaultColor: .yellow)
                }
                print("play and current thread:\(currentThread)")
            }  else {
               PlayerManager.shared.player.stop()
                print("stop and current thread:\(currentThread)")
            }
            objectWillChange.send()
        }
    }
    
    var radioItem : RadioItem
    init(radioItem:RadioItem, delegate: RadioItemListDelegate?, itemStatesInList :ItemStatesInList = .Middle) {
        self.radioItem = radioItem
        self.delegate = delegate
        self.itemStatesInList = itemStatesInList
    }
    
    var streamTitle: String = defaultStreamTitle
    {
        willSet {
            streamTitleWillChange.send(newValue)
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
    
    var pushed = false
    {
        willSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "statueBarChanged"), object: nil, userInfo: ["hidden" : newValue])
            objectWillChange.send()
        }
    }
    
    var backButtonOffsetY: CGFloat = -backButtonPositionY
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    var delegate: RadioItemListDelegate?
    
    var itemStatesInList: ItemStatesInList = .Middle
    
    func nextStation() {
        guard self.delegate != nil else {
            return
        }
        
        self.delegate?.nextStation()
    }
    
    func previousStation() {
        guard self.delegate != nil else {
            return
        }
        
        self.delegate?.previousStation()
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
        return color.hslColor.shiftHue(by: 0.35).shiftSaturation(by: -0.42).shiftBrightness(by: 0.53).uiColor
    }
    
    
    let objectWillChange = ObservableObjectPublisher()
    let streamTitleWillChange = PassthroughSubject<String, Never>()
}


extension RadioStationPlayable {
   
    static func radionStationExample() -> RadioStationPlayable {
        let radioStation = RadioStationPlayable(radioItem: RadioItem(title: "Dance UK Radio", streamURL: .danceUK, imageName: "danceUK"), delegate: nil)
        radioStation.isPlaying = true
        return radioStation
    }
}

protocol Playable {
    var isPlaying : Bool { get set }
    var streamTitle : String { get set }
    var radioItem : RadioItem { get set }
    var delegate : RadioItemListDelegate? { get set }
    var itemStatesInList: ItemStatesInList { get set }
    func nextStation()
    func previousStation()
    
    
}

enum ItemStatesInList {
    case First, Middle, Last
}

enum RadioURL: String {
    case danceUK = "http://uk2.internet-radio.com:8024/stream"
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
    case veniceClassicItalia = "http://174.36.206.197:8000/stream"
    case austinBluesRadio = "http://ca10.rcast.net:8036/stream"
    case soundFusion = "http://uk6.internet-radio.com:8346/stream"
    case asiaDream = "http://66.70.187.44:9029/stream"
    case jpopproject = "http://184.75.223.178:8083/stream"
    case pure90sRadio = "http://185.105.4.100:8183/stream"
}

class RadioItems : ObservableObject, RadioItemListDelegate {
    init() {
        self.values = [
            RadioStationPlayable(radioItem: RadioItem(title: "Dance UK Radio", streamURL: .danceUK, imageName: "danceUK"), delegate: self, itemStatesInList: .First),
            RadioStationPlayable(radioItem: RadioItem(title: "Box UK Radio", streamURL: .boxUK, imageName: "boxUK"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Sound Fusion Radio", streamURL: .soundFusion, imageName: "soundFusion"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Country 105 FM", streamURL: .countryRadio, imageName: "countryRadio"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Americas Country", streamURL: .americasCountry, imageName: "americasCountry"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Pure 90s Radio", streamURL: .pure90sRadio, imageName: "pure90s"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Venice Classic Radio Italia", streamURL: .veniceClassicItalia, imageName: "veniceClassic"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Austin Blues Radio", streamURL: .austinBluesRadio, imageName: "austinBlues"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "PowerPlay Kawaii", streamURL: .asiaDream, imageName: "asiaDream"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "J-Pop Project Radio", streamURL: .jpopproject, imageName: "jpopproject"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Record Drum'n'Bass", streamURL: .rrDrumAndBass, imageName: "radioRecord"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "DFM Pop Dance", streamURL: .dfmPopDance, imageName: "dfmPopDance"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "DFM Russian Dance", streamURL: .dfmRussianDance, imageName: "russianDance"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records Russian Hits", streamURL: .rrRussianHits, imageName: "rrRussianHits"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records EDM Hits", streamURL: .rrEDMHits, imageName: "rrEdmHits"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Bat Yam 89.1 FM", streamURL: .batYamRadioRus, imageName: "batYamRussian"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records Russian Gold", streamURL: .rrRussianGold, imageName: "rrRussianGold"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "DnB My Radio", streamURL: .dnbMyRadio, imageName: "dnbMyRadio"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Record Future House", streamURL: .rrFutureHouse, imageName: "rrFutureHouse"), delegate: self, itemStatesInList: .Last)
                ]
    }
   @Published var values: [RadioStationPlayable] =  [RadioStationPlayable]()
    
    @Published var currentStationIndex: Int = 0
    
    
    func previousStation() {
        guard self.currentStationIndex > 0 else {
            return
        }
        self.values[self.currentStationIndex].isPlaying = false
        self.currentStationIndex -= 1
        self.values[self.currentStationIndex].isPlaying = true
    }
    
    func nextStation() {
        guard self.currentStationIndex < self.values.count - 1 else  {
            return
        }
        self.values[self.currentStationIndex].isPlaying = false
        self.currentStationIndex += 1
        self.values[self.currentStationIndex].isPlaying = true
    }
}


protocol RadioItemListDelegate {
    func previousStation()
    func nextStation()
}

class NavigationPopGestionManager: NSObject, UIGestureRecognizerDelegate {
    var nc:UINavigationController
    
    
    init(nc:UINavigationController) {
        self.nc = nc
    }
    
    func setGestureRecongizerDelegate() {
        self.nc.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        return nc.viewControllers.count <= 1 ? false : true
    }
}
