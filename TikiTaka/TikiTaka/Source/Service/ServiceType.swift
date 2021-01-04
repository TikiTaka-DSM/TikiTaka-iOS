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
    
    typealias httpResult = Observable<(HTTPURLResponse, Data)>

    func requestData(_ api: TikiTakaAPI) -> httpResult {
        return RxAlamofire.requestData(api.method, api.path, parameters: api.params, encoding: JSONEncoding.prettyPrinted, headers: api.headers, interceptor: nil)
    }
    
}
