//
//  SocketManager.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/18.
//

import Foundation
import SocketIO

class socket: NSObject {
    static let shared = socket()
    
    var manager = SocketManager(socketURL: URL(string: ""), config: [.log(false, .compress)])
}
