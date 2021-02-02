//
//  Color.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import Foundation
import UIKit

protocol Point {
    static func pointHex(hex: String) -> UIColor
}
extension Point {
    static func pointHex(hex: String) -> UIColor {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0)
        )
    }
}

struct PointColor: Point {
    static let primary = pointHex(hex: "FFA48E")
    static let sub = pointHex(hex: "FD896C")
    static let enable = pointHex(hex: "FEC9B9")
}
