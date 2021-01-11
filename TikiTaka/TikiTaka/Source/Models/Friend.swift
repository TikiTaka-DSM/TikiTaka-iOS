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
    let friends: [Friend]
}

struct Search: Codable {
    let user: Friends
}

struct Section {
    var header: String
    var items: [Friend]
}

extension Section: SectionModelType {
    typealias Item = Friend
    
    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
