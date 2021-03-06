//
//  Profile.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/06.
//

import Foundation

struct Profile: Codable {
    let img: String
    let name: String
    let id: String
    let statusMessage: String
}

struct State: Codable {
    let friend: Bool
    let block: Bool
}

struct ProfileData: Codable {
    let profileData: Profile
}

struct OtherProfile: Codable {
    let profileData: Profile
    let state: State
    let roomData: Roomid
}

struct Tokens: Codable {
    let tokens: TokenData
}

struct TokenData: Codable {
    let accessToken: String
}
