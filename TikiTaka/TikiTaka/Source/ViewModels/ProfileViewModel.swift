//
//  ProfileViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/12.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadProfile: Signal<Void>
        let selectAdd: Driver<String>
        let selectChat: Driver<[String]>
        let selectBlock: Driver<String>
    }
    
    struct Output {
        let loadData: BehaviorRelay<OtherProfile?>
        let postFriend: Signal<String>
        let postChat: Signal<RoomData>
        let postBlock: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = BehaviorRelay<OtherProfile?>(value: nil)
        let postFriend = PublishSubject<String>()
        let postBlock = PublishSubject<String>()
        let postChat = PublishRelay<RoomData>()
        
        input.loadProfile.asObservable().subscribe(onNext: { _ in
            api.getOtherProfile("").subscribe(onNext: { data, response in
                switch response {
                case .success:
                    loadData.accept(data!)
                default:
                    print("ss")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectAdd.asObservable().subscribe(onNext: { id in
            api.postFriends(id).subscribe(onNext: { response in
                switch response {
                case .success:
                    postFriend.onCompleted()
                default:
                    postFriend.onNext("친구 추가 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectChat.asObservable().subscribe(onNext: { people in
            api.postRoom(people).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    postChat.accept(data!)
                default:
                    print("채팅하기 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectBlock.asObservable().subscribe(onNext: { id in
            api.blockFriends(id).subscribe(onNext: { response in
                switch response {
                case .success:
                    postBlock.onCompleted()
                default:
                    postBlock.onNext("친구 차단 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(loadData: loadData, postFriend: postFriend.asSignal(onErrorJustReturn: "오류가 발생하여 친구 추가가 되지 않습니다."), postChat: postChat.asSignal(), postBlock: postBlock.asSignal(onErrorJustReturn: "오류가 발생하여 친구 차단이 되지 않습니다."))
    }
}

//private let disposeBag = DisposeBag()
//
//struct Input {
//
//}
//
//struct Output {
//
//}
//
//func transform(input: Input) -> Output {
//    <#code#>
//}
