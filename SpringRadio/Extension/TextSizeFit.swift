//
//  TextSizeFit.swift
//  SpringRadio
//
//  Created by jack on 2020/4/9.
//  Copyright © 2020 jack. All rights reserved.
//

import UIKit

extension UILabel {
    static func calculationTextWidth(text: String, fontSize: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: fontSize))
        return labelSize.width
    }
}
