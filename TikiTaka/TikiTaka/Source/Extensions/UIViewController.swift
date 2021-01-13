//
//  UIViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import UIKit

extension UIViewController {
    func goNext(_ identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setAlert(_ titlt: String) {
        let alert = UIAlertController(title: "알람", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func forCornerRadius(_ object: AnyObject) {
        object.layer?.cornerRadius = object.bounds!.height / 2
    }
}

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            print("didset \(isEnabled)")
        }
        willSet{
            print("willSet \(isEnabled)")
        }
    }
}

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

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
      }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
      }

}
