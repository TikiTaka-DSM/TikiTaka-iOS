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
    
    let baseUrl = ""
    typealias httpResult = Observable<(HTTPURLResponse, Data)>

    func requestData(_ api: TikiTakaAPI) -> httpResult {
        return RxAlamofire.requestData(api.method, baseUrl + api.path, parameters: api.params, encoding: JSONEncoding.prettyPrinted, headers: api.headers)
    }
    
}

enum NetworkPart: Int {
    case success = 200
    case notFound = 404
    case duplication = 409
    case fail = 0
}
