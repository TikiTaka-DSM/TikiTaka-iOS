//
//  Chat.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/12.
//

import Foundation

struct Message: Codable {
    let user: User
    let message: String?
    let photo: String?
    let voice: String?
    let createdAt: String
}

struct User: Codable {
    let name: String
    let img: String
}

struct MessageData: Codable {
    let roomData: RoomInfo
    let messageData: [emitMessage]
}

struct emitMessage: Codable {
    let user: SearchUser
    let message: String?
    let photo: String?
    let voice: String?
    let createdAt: String?
}


