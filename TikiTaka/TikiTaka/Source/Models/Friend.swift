//
//  Friend.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation
import RxDataSources

struct Friend: Codable {
    let id: String
    let img: String?
    let name: String
    let statusMessage: String
}

struct Friends: Codable {
    let friends: [SearchUser]
}

struct Search: Codable {
    let user: [SearchUser]
}

struct SearchUser: Codable {
    let id: String
    let name: String
    let img: String
}

struct ChatList: Codable {
    let roomId: Int
    let user: SearchUser
    let lastMessage: String
}

struct Rooms: Codable {
    let rooms: [ChatList]
}
