//
//  SocketManager.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/18.
//

import Foundation
import SocketIO
import RxCocoa

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: "http://54.180.2.226:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var roomInfo = BehaviorRelay<Int>(value: 0)
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
        
        socket.on(clientEvent: .connect) { (data, ack) in
            self.socket.emit("joinRoom", ["roomId": self.roomInfo.value])
        }
    }
    
}
