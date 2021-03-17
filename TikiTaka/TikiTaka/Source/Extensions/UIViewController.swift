//
//  UIViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import UIKit
import RxCocoa

extension UIViewController {
    func pushVC(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setAlert(_ title: String) {
        let alert = UIAlertController(title: "알람", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func forCornerRadius(_ object: AnyObject) {
        object.layer?.cornerRadius = object.bounds!.height / 2
    }
    
    func navigationBarColor(_ color: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = color
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(element: Element.Element) {
        var array = value
        array.append(element)
        accept(array)
    }
}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}
