//
//  Room.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/12.
//

import Foundation

struct Room: Codable {
    let id: Int
}

struct RoomId: Codable {
    let name: String
}

struct RoomData: Codable {
    let roomData: Room
}

struct RoomInfo: Codable {
    let roomData: RoomId
}
