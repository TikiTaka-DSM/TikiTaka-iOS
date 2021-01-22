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
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = BehaviorRelay<[SearchUser]>(value: [])
        let searchData = BehaviorRelay<[SearchUser]?>(value: nil)
        let selectData = PublishRelay<String>()
        
        input.loadFriends.asObservable().subscribe(onNext: { _ in
            api.getFriends().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    loadData.accept(data!.friends)
                default:
                    print("친구목록이 없습니다.")
                    loadData.accept([])
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectFriend.asObservable().subscribe(onNext: { indexPath in
            let friend = loadData.value
            selectData.accept(friend[indexPath.row].id)
        }).disposed(by: disposeBag)
        
        input.searchFriend.asObservable().withLatestFrom(input.searchName).subscribe(onNext: { name in
            api.searchFriends(name).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    searchData.accept(data!.user)
                default:
                    searchData.accept(nil)
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(loadData: loadData, searchData: searchData.asDriver(), selectData: selectData.asDriver(onErrorJustReturn: ""))
    }


}
