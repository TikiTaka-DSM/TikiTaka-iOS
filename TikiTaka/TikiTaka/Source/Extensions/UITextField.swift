//
//  UITextField.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/16.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func underLine() {
        self.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.width, height: 2)
        border.backgroundColor = PointColor.primary.cgColor
        self.layer.addSublayer(border)
        self.textAlignment = .center
    }
}
