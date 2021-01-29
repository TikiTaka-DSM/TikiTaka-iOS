//
//  Network.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import Foundation
import Alamofire

enum TikiTakaAPI {
    case signIn(_ id: String, _ password: String)
    case signUp(_ id: String, _ password: String, _ name: String)
    
    case getMyProfile
    case getOtherProfile(_ str: String)
    case changeProfile
    
    case getFriends
    case searchFriends(_ name: String)
    case blockFriends(_ name: String)
    case FindFriends(_ name: String)
    case postFriends(_ id: String)
    
    case postRoom(_ people: String)
    case getChatList
    case getChatInfo(_ id: Int)
    
    var path: String {
        switch self {
        case .signIn:
            return "/user/auth"
        case .signUp:
            return "/user"
        case .getMyProfile, .changeProfile:
            return "/profile"
        case .getOtherProfile(let str):
            return "/profile/\(str)"
        case .getFriends:
            return "/friends"
        case .searchFriends(let name):
            return "/friends?name=\(name)"
        case .blockFriends(let name):
            return "friend/block/\(name)"
        case .FindFriends(let name):
            return "/friend?id=\(name)"
        case .postFriends(let id):
            return "/friend/\(id)"
        case .postRoom:
            return "/room"
        case .getChatList:
            return "/rooms"
        case .getChatInfo(let id):
            return "/room/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .signUp, .postFriends, .postRoom:
            return .post
        case .getMyProfile, .getOtherProfile, .getFriends, .searchFriends, .FindFriends, .getChatList, .getChatInfo:
            return .get
        case .changeProfile:
            return .put
        case .blockFriends:
            return .delete
        }
    }
    
    var params: Parameters? {
        switch self {
        case .signIn(let id, let password):
            return ["id": id, "password": password]
        case .signUp(let id, let password, let name):
            return ["id": id, "password": password, "name": name]
        case .postRoom(let people):
            return ["friend": people]
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .signUp, .signIn:
            return nil
        case .getMyProfile, .changeProfile, .getOtherProfile, .getFriends, .searchFriends, .FindFriends, .postRoom, .getChatList:
            let token = String()
            return ["Authorization": "Bearer " + token]
        default:
            return [:]
        }
    }
}
