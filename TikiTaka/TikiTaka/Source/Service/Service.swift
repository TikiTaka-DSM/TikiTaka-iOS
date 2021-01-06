//
//  Service.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import RxSwift

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
}
