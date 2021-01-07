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
    
    func signIn(_ id: String,_ password: String) -> Observable<NetworkPart> {
        connect.requestData(.signIn(id, password)).map { (response, data) -> NetworkPart in
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
    
    func signUp(_ id: String, _ password: String, _ name: String) -> Observable<NetworkPart> {
        connect.requestData(.signUp(id, password, name)).map { (response, data) -> NetworkPart in
            switch response.statusCode {
            case 200:
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
        let baseUrl = ""
        let param = ["name": name, "statusMessage": statusMessage]
        
        return AF.upload(multipartFormData: { (multipartFormData) in
            if img != nil {
                multipartFormData.append(img!, withName: "img", fileName: "image.jpg", mimeType: "image/jpg")
            }

            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
        }, to: baseUrl + api.path, method: .post, headers: api.headers)
    }
}
