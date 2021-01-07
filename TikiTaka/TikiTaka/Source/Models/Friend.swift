//
//  Friend.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation

class Friend: Codable {
    let id: String
    let img: String
    let name: String
    let statusMessage: String
}

class Friends: Codable {
    let friends: [Friend]
}
