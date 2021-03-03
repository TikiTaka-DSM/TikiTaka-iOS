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
        
        socket.on(clientEvent: .connect) {[unowned self] (data, ack) in
            print("romminfo \(roomInfo.value)")
            socket.emit("joinRoom", roomInfo.value)
        }
    }
    
    func disconnection() {
        socket.disconnect()
    }
    
    func sendMessage(_ id: Int, _ token: String, message: String) {
        socket.emit("sendMessage", id, token, message)
    }
    
    func sendImage(_ id: Int, _ token: String, image: String) {
        socket.emit("sendImage", id, token, image)
    }
    
    func sendVoice(_ id: Int, _ token: String, voice: String) {
        socket.emit("sendVoice", id, token, voice)
    }
    
}
