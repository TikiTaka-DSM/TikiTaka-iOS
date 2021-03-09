//
//  TokenManager.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/19.
//

import Foundation

struct TokenManager {
    enum TokenSataus {
        case access
        case refresh
    }
    
    static var currentToken: Tokens? {
        return StoregaeManager.shared.read()
    }
}
