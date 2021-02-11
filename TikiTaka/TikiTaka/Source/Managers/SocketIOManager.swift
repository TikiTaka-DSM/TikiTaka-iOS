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
    
    func sendMessage(_ id: Int, _ token: String, message: String) {
        socket.emit("sendMessage", ["roomId" : id, "token" : token, "message": message])
    }
    
    func sendImage(_ id: Int, _ token: String, image: String) {
        socket.emit("sendImage", ["roomId" : id, "token" : token, "file": image])
    }
    
    func sendVoice(_ id: Int, _ token: String, voice: String) {
        socket.emit("sendVoice", ["roomId" : id, "token": token, "file": voice])
    }
    
}
