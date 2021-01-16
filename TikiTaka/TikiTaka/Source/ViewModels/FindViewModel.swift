//
//  FindViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/16.
//

import Foundation
import RxSwift
import RxCocoa

class FindViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let findFriend: Signal<String>
    }
    
    struct Output {
        let findData: Driver<SearchUser?>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let findData = BehaviorRelay<SearchUser?>(value: nil)
        
        input.findFriend.asObservable().subscribe(onNext: { name in
            api.findFriends(name).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    findData.accept(data!.user)
                default:
                    findData.accept(nil)
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(findData: findData.asDriver())
    }
}
