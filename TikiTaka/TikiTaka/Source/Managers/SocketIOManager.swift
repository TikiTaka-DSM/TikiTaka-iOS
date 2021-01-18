//
//  SocketManager.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/18.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: "")!, config: [.log(false), .compress])
    var socket: SocketIOClient!

    override init() {
        super.init()
        
        socket = self.manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendMessage(roomId: String, message: String, token: String) -> [String : Any] {
        return ["roomId" : roomId, "message" : message , "token" : token ]
    }
    
    func sendImage(roomId: String, image: Data, token: String) -> [String: Any] {
        return ["roomId": roomId, "image": image, "token": token]
    }
    
    func sendAudio(roomId: String, audio: Data, token: String) -> [String: Any] {
        return ["roomId": roomId, "audio": audio, "token": token]
    }
    

}
