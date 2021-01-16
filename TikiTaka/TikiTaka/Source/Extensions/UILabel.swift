//
//  UILabel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/16.
//

import Foundation
import UIKit

extension UILabel{
    func underLine(){
        if let textUnwrapped = self.text{
            let textColor: UIColor = .black
            let underLineColor: UIColor = PointColor.primary
            let underlineAttribute = NSUnderlineStyle.single.rawValue
            let labelAtributes:[NSAttributedString.Key : Any]  = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.underlineStyle: underlineAttribute,
                NSAttributedString.Key.underlineColor: underLineColor
            ]
            let underlineAttributedString = NSAttributedString(string: textUnwrapped, attributes: labelAtributes)
            self.attributedText = underlineAttributedString
        }
    }
}
