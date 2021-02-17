//
//  Service.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import RxSwift
import Alamofire

class Service {

    let connect = ServiceType()
    
    func signIn(_ id: String,_ password: String) -> Observable<(NetworkPart)> {
        connect.requestData(.signIn(id, password)).map { (response, data) -> (NetworkPart) in
            print(response.statusCode)
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(Tokens.self, from: data) else { return (.fail) }

                if StoregaeManager.shared.create(data) { return (.success) }
                
                return (.fail)
            case 404:
                return (.notFound)
            default:
                return (.fail)
            }
        }
    }
    
    func signUp(_ id: String, _ password: String, _ name: String) -> Observable<NetworkPart> {
        connect.requestData(.signUp(id, password, name)).map { (response, data) -> NetworkPart in
            switch response.statusCode {
            case 201:
                return .success
            case 409:
                return .duplication
            default:
                return .fail
            }
        }
    }
    
    func getMyProfile() -> Observable<(ProfileData?, NetworkPart)> {
        connect.requestData(.getMyProfile).map { (response, data) -> (ProfileData?, NetworkPart) in
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(ProfileData.self, from: data) else { return (nil, .fail)}
                return (data, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
    func changeProfile(_ img: Data?, _ name: String, statusMessage: String) -> DataRequest {
        let api: TikiTakaAPI = .changeProfile
        let param = ["name": name, "statusMessage": statusMessage]
        
        return AF.upload(multipartFormData: { (multipartFormData) in
            if img != nil {
                multipartFormData.append(img!, withName: "img", fileName: "image.jpg", mimeType: "image/jpg")
            }else{
                multipartFormData.append("".data(using: .utf8)!, withName: "img", fileName: "image", mimeType: "image/jpg")
            }

            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
        }, to: Config.baseURL + api.path, method: api.method, headers: api.headers)
    }
    
    func getFriends() -> Observable<(Friends?, NetworkPart)> {
        connect.requestData(.getFriends).map { (response, data) -> (Friends?, NetworkPart) in
            print(response.statusCode)
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(Friends.self, from: data) else { return (nil, .fail) }
                
                return (data, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
    func getOtherProfile(_ str: String) -> Observable<(OtherProfile?, NetworkPart)> {
        connect.requestData(.getOtherProfile(str)).map { (response, data) -> (OtherProfile?, NetworkPart) in
            print(response.statusCode)
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(OtherProfile.self, from: data) else { return (nil, .fail) }
                
                return (data, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
    func searchFriends(_ name: String) -> Observable<(Search?, NetworkPart)> {
        connect.requestData(.searchFriends(name)).map { (response, data) -> (Search?, NetworkPart) in
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(Search.self, from: data) else { return (nil, .fail) }
                
                return (data, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
    func blockFriends(_ name: String) -> Observable<NetworkPart> {
        connect.requestData(.blockFriends(name)).map { (response, data) -> NetworkPart in
            switch response.statusCode {
            case 200:
                return .success
            default:
                return .fail
            }
        }
    }
    
    func findFriends(_ name: String) -> Observable<NetworkPart> {
        connect.requestData(.FindFriends(name)).map { (response, data) -> (NetworkPart) in
            switch response.statusCode {
            case 200:
                return .success
            case 404:
                return .notFound
            default:
                return .fail
            }
        }
    }
    
    func postFriends(_ id: String) -> Observable<NetworkPart> {
        connect.requestData(.postFriends(id)).map { (response, data) -> NetworkPart in
            switch response.statusCode {
            case 200:
                return .success
            default:
                return .fail
            }
        }
    }
    
    func postRoom(_ people: String) -> Observable<(RoomData?, NetworkPart)> {
        connect.requestData(.postRoom(people)).map { (response, data) -> (RoomData?, NetworkPart) in
            print(response.statusCode)
            switch response.statusCode {
            case 201, 200:
                guard let data = try? JSONDecoder().decode(RoomData.self, from: data) else { return (nil, .fail)}
                
                return (data, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
    func getChatList() -> Observable<([ChatList]?, NetworkPart)> {
        connect.requestData(.getChatList).map { (response, data) -> ([ChatList]?, NetworkPart) in
            print(response.statusCode)
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(Rooms.self, from: data) else { return (nil, .fail)}
                
                return (data.rooms, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
    func getChatInfo(_ id: Int) -> Observable<(MessageData?, NetworkPart)> {
        connect.requestData(.getChatInfo(id)).map { (response, data) -> (MessageData?, NetworkPart) in
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(MessageData.self, from: data) else { return (nil, .fail) }
                
                return (data, .success)
            default:
                return (nil, .fail)
            }
        }
    }
    
}
