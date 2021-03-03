//
//  FriendViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation
import RxSwift
import RxCocoa

final class FriendViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadFriends: Signal<Void>
        let selectFriend: Signal<IndexPath>
        let searchName: Signal<String>
        let searchFriend: Signal<Void>
    }
    
    struct Output {
        let loadData: BehaviorRelay<[SearchUser]>
        let searchData: Driver<[SearchUser]?>
        let selectData: Driver<String>
        let message: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = BehaviorRelay<[SearchUser]>(value: [])
        let searchData = BehaviorRelay<[SearchUser]?>(value: nil)
        let selectData = PublishRelay<String>()
        let message = PublishSubject<String>()

        input.loadFriends.asObservable().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            api.getFriends().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    loadData.accept(data!.friends)
                default:
                    message.onNext("친구목록이 없습니다.")
                    loadData.accept([])
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectFriend.asObservable().subscribe(onNext: { indexPath in
            let friend = loadData.value
            selectData.accept(friend[indexPath.row].id)
        }).disposed(by: disposeBag)
        
        input.searchFriend.asObservable().withLatestFrom(input.searchName).subscribe(onNext: {[weak self] name in
            guard let self = self else { return }
            api.searchFriends(name).subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .success:
                    loadData.accept(data!.users)
                default:
                    message.onNext("해당 아이디를 가진 친구가 없습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(loadData: loadData, searchData: searchData.asDriver(), selectData: selectData.asDriver(onErrorJustReturn: ""), message: message.asSignal(onErrorJustReturn: ""))
    }
}
