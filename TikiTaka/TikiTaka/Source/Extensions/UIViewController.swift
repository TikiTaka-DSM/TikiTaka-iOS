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
    func goNext(_ identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
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
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
    
    func insert(element: Element.Element) {
        var array = self.value
        array.insert(element, at: 0 as! Element.Index)
        self.accept(array)
    }
}
