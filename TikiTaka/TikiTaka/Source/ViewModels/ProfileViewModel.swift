//
//  ProfileViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/12.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadProfile: Signal<Void>
        let friendId: String
        let selectAdd: Driver<Void>
        let selectChat: Driver<Void>
        let selectBlock: Driver<Void>
    }
    
    struct Output {
        let loadData: PublishRelay<OtherProfile>
        let postFriend: Signal<String>
        let postChat: Signal<RoomData?>
        let postBlock: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = PublishRelay<OtherProfile>()
        let postFriend = PublishSubject<String>()
        let postBlock = PublishSubject<String>()
        let postChat = PublishSubject<RoomData?>()
        
        input.loadProfile.asObservable().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            api.getOtherProfile(input.friendId).subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .success:
                    loadData.accept(data!)
                default:
                    print("프로필 정보 로드 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectAdd.asObservable().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            api.postFriends(input.friendId).subscribe(onNext: { response in
                print(response)
                switch response {
                case .success:
                    postFriend.onCompleted()
                default:
                    postFriend.onNext("친구 추가 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectChat.asObservable().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            api.postRoom(input.friendId).subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .success:
                    postChat.onNext(data!)
                case .duplication:
                    postChat.onCompleted()
                default:
                    postChat.onCompleted()
                    print("채팅하기 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectBlock.asObservable().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            api.blockFriends(input.friendId).subscribe(onNext: { response in
                switch response {
                case .success:
                    postBlock.onCompleted()
                default:
                    postBlock.onNext("친구 차단 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(loadData: loadData, postFriend: postFriend.asSignal(onErrorJustReturn: "오류가 발생하여 친구 추가가 되지 않습니다."), postChat: postChat.asSignal(onErrorJustReturn: nil), postBlock: postBlock.asSignal(onErrorJustReturn: "오류가 발생하여 친구 차단이 되지 않습니다."))
    }
}
