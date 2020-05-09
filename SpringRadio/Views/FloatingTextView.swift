//
//  FloatingTextView.swift
//  SpringRadio
//
//  Created by jack on 2020/5/8.
//  Copyright © 2020 jack. All rights reserved.
//

import UIKit

enum FloatTextOrientation: Int {
    case vertical = 0, horizontal, positiveTilt, negativeTilt
}

var screenWidth = UIApplication.shared.windows[0].bounds.width
var screenHeight = UIApplication.shared.windows[0].bounds.height

class FloatingTextView: UIView {

    let floatTitleFontSize: CGFloat = 180.0
    let streamTitleFontSize: CGFloat = 50.0
    
    private var titleWidth:CGFloat = 0.0
    private var streamTitleWidth:CGFloat = 0.0
    
    var titleStr: String = "" {
        didSet {
            self.titleLabel.text = titleStr
            titleWidth = UILabel.calculationTextWidth(text: titleStr, fontSize: floatTitleFontSize)
            self.titleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y, width: titleWidth, height: 200)
        }
    }
    
    var streamTitleStr: String  = "" {
        didSet {
            self.streamTitleLabel.text = streamTitleStr
            streamTitleWidth = UILabel.calculationTextWidth(text: streamTitleStr, fontSize: streamTitleFontSize)
            self.streamTitleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y, width: streamTitleWidth, height: 70)
        }
    }
    
    var orientation: FloatTextOrientation = .horizontal
    {
        didSet {
            action()
        }
    }
    
    var canFloat:Bool = false
    {
        willSet {
            if canFloat != newValue {
                if newValue {
                    orientation = FloatTextOrientation(rawValue: Int.random(in: 0...3)) ?? .horizontal
                } else {
                    self.titleLabel.layer.removeAllAnimations()
                    self.streamTitleLabel.layer.removeAllAnimations()
                }
                
            }
        }
    }
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: floatTitleFontSize)
        label.textColor = UIColor.white
        label.alpha = 0.65
        return label
    }()
    
    lazy var streamTitleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: streamTitleFontSize)
        label.textColor = UIColor.white
        label.alpha = 0.85
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(streamTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func twistLabel(angle: CGFloat) {
        self.titleLabel.rotate(angle: angle)
        self.streamTitleLabel.rotate(angle: angle)
    }
    
    func action() {
        print("action!")
        switch orientation {
        case .horizontal:
            self.rotate(angle: 0)
        case .vertical:
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.height, height: self.frame.width))
            self.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            self.rotate(angle: 90)
        case .positiveTilt:
            self.rotate(angle: 45)
        case .negativeTilt:
            self.rotate(angle: -45)
        }
        
        let location = convertEndLocation(orientation: orientation)
        
        UIView.animate(withDuration: Double.random(in: 15.0...20.0), delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            var titleX = strongSelf.titleLabel.frame.origin.x
            if titleX != -location.startTitleX {
                titleX = -location.startTitleX
            } else {
                titleX = location.distanceTitleX
            }
            
            strongSelf.titleLabel.frame = CGRect(x: titleX, y: strongSelf.titleLabel.frame.origin.y, width: strongSelf.titleLabel.frame.width, height: strongSelf.titleLabel.frame.height)
            
            var streamTitleX = strongSelf.streamTitleLabel.frame.origin.x
            if streamTitleX != location.distanceStreamTitleX {
                streamTitleX = location.distanceStreamTitleX
            } else {
                streamTitleX = location.startStreamTitleX
            }
            
            strongSelf.streamTitleLabel.frame = CGRect(x: streamTitleX, y: strongSelf.streamTitleLabel.frame.origin.y, width: strongSelf.streamTitleLabel.frame.width, height: strongSelf.streamTitleLabel.frame.height)
            
            
        }, completion: { [weak self] finished in
            guard let strongSelf = self else { return }
            switch strongSelf.orientation {
            case .horizontal:
                 strongSelf.rotate(angle: 0)
            case .vertical:
                strongSelf.rotate(angle: -90)
                strongSelf.frame = CGRect(origin: strongSelf.frame.origin, size: CGSize(width: strongSelf.frame.height, height: strongSelf.frame.width))
                
            case .positiveTilt:
                strongSelf.rotate(angle: -45)
            case .negativeTilt:
                strongSelf.rotate(angle: 45)
            }
            
            if strongSelf.canFloat && finished {
                strongSelf.orientation = FloatTextOrientation(rawValue: Int.random(in: 0...3)) ?? .horizontal
            }
        })
        
    }
    
    func convertEndLocation(orientation:FloatTextOrientation) -> (startTitleX:CGFloat, startStreamTitleX:CGFloat ,distanceTitleX: CGFloat, distanceStreamTitleX: CGFloat) {
        var titleX:CGFloat = 0.0
        var streamTitleX:CGFloat = 0.0
                switch orientation {
                case .horizontal:
                    titleX = -self.titleWidth
                    streamTitleX = screenWidth
                case .vertical:
                    titleX = -self.titleWidth
                    streamTitleX = screenHeight + 64
                case .positiveTilt:
                    titleX = -self.titleWidth * 1.42 - 200 * 1.42
                    streamTitleX = screenWidth * 1.42 + 80 * 1.42
                case .negativeTilt:
                    titleX = -self.titleWidth * 1.42 - 200 * 1.42
                    streamTitleX = screenWidth * 1.42 + 80 * 1.42
                }
            
            var distanceTitleX:CGFloat = 0.0
            var distanceStreamTitleX:CGFloat = 0.0
            
        var titleY:CGFloat = 0.0
        var streamTitleY:CGFloat = 0.0
        
            switch orientation {
            case .horizontal:
                titleY = CGFloat(Float.random(in: -140.0...140.0)) + screenHeight / 2
                streamTitleY = titleY + 150.0
                distanceTitleX = screenWidth
                distanceStreamTitleX = -streamTitleWidth
                
            case .vertical:
                titleY = CGFloat(Float.random(in: -60.0...60.0)) + screenWidth / 2 - (floatTitleFontSize + streamTitleFontSize) / 2
                streamTitleY = titleY - 25.0
                distanceTitleX = screenHeight + 64
                distanceStreamTitleX = -streamTitleWidth
                
            case .positiveTilt:
                titleY = CGFloat(Float.random(in: -50.0...50.0)) + screenWidth / 2 - 200
                streamTitleY = titleY + 150.0
                distanceTitleX = screenWidth * 1.42
                distanceStreamTitleX = -streamTitleWidth * 1.42  - 70 * 1.42
                
            case .negativeTilt:
                titleY = CGFloat(Float.random(in: -50.0...50.0)) + screenWidth / 2 + 200
                streamTitleY = titleY - 20
                distanceTitleX = screenWidth / 1.42
                distanceStreamTitleX = -streamTitleWidth * 1.42 - 70 * 1.42
            }
        
        self.titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleLabel.frame.width , height: titleLabel.frame.height)
        self.streamTitleLabel.frame = CGRect(x: streamTitleX, y: streamTitleY, width: streamTitleLabel.frame.width, height: streamTitleLabel.frame.height)
        
        print("\(self.titleLabel)  \(self.streamTitleLabel)")
        
        return (titleX, streamTitleX, distanceTitleX, distanceStreamTitleX)
    }
    
}

extension UIView {
    /**
     Rotate a view by specified degrees

     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }

}
