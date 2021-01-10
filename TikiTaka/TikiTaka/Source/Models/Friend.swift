//
//  Friend.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation

struct Friend: Codable {
    let id: String
    let img: String?
    let name: String
    let statusMessage: String
}

struct Friends: Codable {
    let friends: [Friend]
}

struct Search: Codable {
    let user: Friends
}
