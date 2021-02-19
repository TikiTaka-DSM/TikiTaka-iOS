//
//  ServiceType.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import Foundation

enum NetworkPart: Int, Error {
    case success = 200
    case notFound = 404
    case duplication = 409
    case fail = 0
}

