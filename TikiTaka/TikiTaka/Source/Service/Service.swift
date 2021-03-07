//
//  Service.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import RxSwift
import Moya

class Service {
    
    let provider = MoyaProvider<TikiTakaAPI>()
    
    func signIn(_ id: String,_ password: String) -> Observable<(NetworkPart)> {
        return provider.rx.request(.signIn(id, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Tokens.self)
            .map { token -> (NetworkPart) in
                if StoregaeManager.shared.create(token) { return (.success) }
                return (.fail)
            }.catchError { [unowned self] in return .just(self.setNetworkError($0)) }
    }
    
    func signUp(_ id: String, _ password: String, _ name: String) -> Observable<NetworkPart> {
        return provider.rx.request(.signUp(id, password, name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> NetworkPart in
                return (.success)
            }.catchError { [unowned self] in return .just(self.setNetworkError($0)) }
    }
    
    func getMyProfile() -> Observable<(ProfileData?, NetworkPart)> {
        return provider.rx.request(.getMyProfile)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(ProfileData.self)
            .map { return ($0, .success) }
            .catchError { _ in return .just((nil, .fail)) }
    }
    
    func changeProfile(_ img: Data?, _ name: String, statusMessage: String) -> Observable<NetworkPart> {
        return provider.rx.request(.changeProfile(name, statusMessage, img))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ in return (.success) }
            .catchError{ _ in return .just(.fail) }
    }
    
    func getFriends() -> Observable<(Friends?, NetworkPart)> {
        return provider.rx.request(.getFriends)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Friends.self)
            .map { return ($0, .success) }
            .catchError { _ in .just((nil, .fail)) }
    }
    
    func getOtherProfile(_ str: String) -> Observable<(OtherProfile?, NetworkPart)> {
        return provider.rx.request(.getOtherProfile(str))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(OtherProfile.self)
            .map { return ($0, .success) }
            .catchError { _ in .just((nil, .fail))}
    }
    
    func searchFriends(_ name: String) -> Observable<(Search?, NetworkPart)> {
        return provider.rx.request(.searchFriends(name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Search.self)
            .map { return ($0, .success) }
            .catchError{[unowned self] error in .just((nil, self.setNetworkError(error)))}
    }
    
    func blockFriends(_ name: String) -> Observable<NetworkPart> {
        return provider.rx.request(.blockFriends(name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> NetworkPart in
                return (.success)
            }.catchError{ error in .just(self.setNetworkError(error)) }
    }
    
    func findFriends(_ name: String) -> Observable<NetworkPart> {
        return provider.rx.request(.findFriend(name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> NetworkPart in
                return (.success)
            }.catchError { [unowned self] in .just( setNetworkError($0)) }
    }
    
    func postFriends(_ id: String) -> Observable<NetworkPart> {
        return provider.rx.request(.postFriends(id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> NetworkPart in
                return (.success)
            }.catchError { _ in .just(.fail) }
    }
    
    func postRoom(_ people: String) -> Observable<(RoomData?, NetworkPart)> {
        return provider.rx.request(.postRoom(people))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(RoomData.self)
            .map { return ($0, .success) }
            .catchError { _ in return .just((nil, .fail)) }
    }
    
    func getChatList() -> Observable<([ChatList]?, NetworkPart)> {
        return provider.rx.request(.getChatList)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Rooms.self)
            .map { return ($0.rooms, .success) }
            .catchError { _ in return .just((nil, .fail)) }
    }
    
    func getChatInfo(_ id: Int) -> Observable<(MessageData?, NetworkPart)> {
        return provider.rx.request(.getChatInfo(id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(MessageData.self)
            .map { return ($0, .success) }
            .catchError { _ in return .just((nil, .fail)) }
    }
    
    func setNetworkError(_ error: Error) -> NetworkPart {
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fail) }
        print(error)
        return (NetworkPart(rawValue: status) ?? .fail)
    }
}
