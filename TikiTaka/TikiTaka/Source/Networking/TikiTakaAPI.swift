//
//  Network.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import Foundation
import Moya

enum TikiTakaAPI {
    
    case signIn(_ id: String, _ password: String)
    case signUp(_ id: String, _ password: String, _ name: String)
    
    case getMyProfile
    case getOtherProfile(_ str: String)
    case changeProfile(_ name: String, _ statusMessage: String, _ img: Data?)
    
    case getFriends
    case searchFriends(_ name: String)
    case blockFriends(_ name: String)
    case findFriend(_ name: String)
    case postFriends(_ id: String)
    
    case postRoom(_ people: String)
    case getChatList
    case getChatInfo(_ id: Int)
}

extension TikiTakaAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.2.226:5000")!
    }
    
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
        case .searchFriends:
            return "/friends/search"
        case .blockFriends(let name):
            return "friend/block/\(name)"
        case .findFriend:
            return "/friend"
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
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .postFriends, .postRoom:
            return .post
        case .getMyProfile, .getOtherProfile, .getFriends, .searchFriends, .findFriend, .getChatList, .getChatInfo:
            return .get
        case .changeProfile, .blockFriends:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .signIn(let id, let password):
            return .requestParameters(parameters: ["id": id, "password": password], encoding: JSONEncoding.prettyPrinted)
        case .signUp(let id, let password, let name):
            return .requestParameters(parameters: ["id": id, "password": password, "name": name], encoding: JSONEncoding.prettyPrinted)
        case .postRoom(let people):
            return .requestParameters(parameters: ["friend": people], encoding: JSONEncoding.prettyPrinted)
        case .changeProfile(let name, let statusMessage, let img):
            return .uploadMultipart([Moya.MultipartFormData(provider: .data(img ?? Data()), name: "img", fileName: "image.jpg", mimeType: "image/jpg"),
                                     Moya.MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name", mimeType: "text/plain"),
                                     Moya.MultipartFormData(provider: .data(statusMessage.data(using: .utf8)!), name: "statusMessage", mimeType: "text/plain")])
        case .searchFriends(let name):
            return .requestParameters(parameters: ["name":name],
                                    encoding: URLEncoding.queryString)
        case .findFriend(let name):
            return .requestParameters(parameters: ["id": name], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .signIn:
            return nil
        case .getMyProfile, .changeProfile, .getOtherProfile, .getFriends, .searchFriends, .findFriend, .postRoom, .getChatList, .getChatInfo, .blockFriends:
            guard let token = TokenManager.currentToken?.tokens.accessToken else { return nil }
            return ["Authorization" : "Bearer " + token]
        default:
            return nil
        }
    }
}
