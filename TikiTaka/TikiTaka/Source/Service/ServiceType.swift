//
//  ServiceType.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift

class ServiceType {
    
    typealias HTTPResult = Observable<(HTTPURLResponse, Data)>

    func requestData(_ api: TikiTakaAPI) -> HTTPResult {
        return RxAlamofire.requestData(api.method, Config.baseURL + api.path, parameters: api.params, encoding: JSONEncoding.prettyPrinted, headers: api.headers)
    }
    
}

enum NetworkPart: Int {
    case success = 200
    case notFound = 404
    case duplication = 409
    case fail = 0
}
