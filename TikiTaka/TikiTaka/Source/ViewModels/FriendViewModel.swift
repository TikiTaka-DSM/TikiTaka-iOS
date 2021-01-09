//
//  FriendViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation
import RxSwift
import RxCocoa

class FriendViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadFriends: Signal<Void>
    }
    
    struct Output {
        let loadData: BehaviorRelay<Friends?>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = BehaviorRelay<Friends?>(value: nil)
        
        input.loadFriends.asObservable().subscribe(onNext: { _ in
            api.getFriends().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    loadData.accept(data!)
                default:
                    print("df")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(loadData: loadData)
    }


}
