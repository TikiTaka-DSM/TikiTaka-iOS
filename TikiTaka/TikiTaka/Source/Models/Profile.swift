//
//  Profile.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/06.
//

import Foundation

class Profile: Codable {
    let img: String
    let name: String
    let statusMessage: String
}

class ProfileData: Codable {
    let profileData: Profile
}
