//
// AudioSpectrum02
// A demo project for blog: https://juejin.im/post/5c1bbec66fb9a049cb18b64c
// Created by: potato04 on 2019/1/30
//

import UIKit




class SpectrumView: UIView {
    
    var barWidth: CGFloat = 3.0
    var space: CGFloat = 1.0
    
//    var rightColors = [UIColor.init(red: 52/255, green: 232/255, blue: 158/255, alpha: 1.0).cgColor,
//                       UIColor.init(red: 15/255, green: 52/255, blue: 67/255, alpha: 1.0).cgColor] {
//        didSet {
//            rightGradientLayer.colors = rightColors
//        }
//    }
//    var leftColors = [UIColor.init(red: 194/255, green: 21/255, blue: 0/255, alpha: 1.0).cgColor,
//    UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1.0).cgColor]
//    {
//        didSet {
//            leftGradientLayer.colors = leftColors
//        }
//    }
    let leftColors = [UIColor(red: 253/255, green: 229/255, blue: 241/255, alpha: 0.7).cgColor,
                      UIColor(red: 235/255, green: 2/255, blue: 119/255, alpha: 0.8).cgColor]
    let rightColors = [UIColor(red: 253/255, green: 229/255, blue: 241/255, alpha: 0.7).cgColor,
                       UIColor(red: 86/255, green: 40/255, blue: 123/255, alpha: 0.8).cgColor]
                       
    
    private let bottomSpace: CGFloat = 0.0
    private let topSpace: CGFloat = 0.0
    
    var leftGradientLayer = CAGradientLayer()
    var rightGradientLayer = CAGradientLayer()

    
    var spectra:[[Float]]? {
        didSet {
            if let spectra = spectra {
                // left channel
                let leftPath = UIBezierPath()
                for (i, amplitude) in spectra[0].enumerated() {
                    let x = CGFloat(i) * (barWidth + space) + space
                    let y = translateAmplitudeToYPosition(amplitude: amplitude)
                    let bar = UIBezierPath(rect: CGRect(x: x, y: y, width: barWidth, height: bounds.height - bottomSpace - y))
                    leftPath.append(bar)
                }
                
                let leftMaskLayer = CAShapeLayer()
                leftMaskLayer.path = leftPath.cgPath
                 
                leftGradientLayer.frame = CGRect(x: 0, y: topSpace, width: bounds.width, height: bounds.height - topSpace - bottomSpace)
                leftGradientLayer.mask = leftMaskLayer
                 leftGradientLayer.shouldRasterize = true
                 leftGradientLayer.drawsAsynchronously = true
                 leftGradientLayer.isOpaque = true
                
                // right channel
                if spectra.count >= 2 {
                    let rightPath = UIBezierPath()
                    for (i, amplitude) in spectra[1].enumerated() {
                        let x = CGFloat(spectra[1].count - 1 - i) * (barWidth + space) + space
                        let y = translateAmplitudeToYPosition(amplitude: amplitude)
                        let bar = UIBezierPath(rect: CGRect(x: x, y: y, width: barWidth, height: bounds.height - bottomSpace - y))
                        rightPath.append(bar)
                    }
                    let rightMaskLayer = CAShapeLayer()
                    rightMaskLayer.path = rightPath.cgPath
                 
                    rightGradientLayer.frame = CGRect(x: 0, y: topSpace, width: bounds.width, height: bounds.height - topSpace - bottomSpace)
                    rightGradientLayer.mask = rightMaskLayer
                 rightGradientLayer.shouldRasterize = true
                 rightGradientLayer.drawsAsynchronously = true
                 rightGradientLayer.isOpaque = true
                }
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.layer.contentsScale = UIScreen.main.scale
        
        leftGradientLayer.colors = leftColors
        leftGradientLayer.locations = [0.6, 1.0]

        self.layer.addSublayer(leftGradientLayer)
    
        
        rightGradientLayer.colors = rightColors
        rightGradientLayer.locations = [0.7, 1.0]
        self.layer.addSublayer(rightGradientLayer)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.isOpaque = true
    }
    
    private func translateAmplitudeToYPosition(amplitude: Float) -> CGFloat {
        let barHeight: CGFloat = CGFloat(amplitude) * (bounds.height - bottomSpace - topSpace)
        return bounds.height - bottomSpace - barHeight
    }
}
