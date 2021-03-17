//
//  FindViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/16.
//

import Foundation
import RxSwift
import RxCocoa

final class FindViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let friendName: Driver<String>
        let findFriend: Driver<Void>
    }
    
    struct Output {
        let findData: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let findData = PublishSubject<String>()
        
        input.findFriend.asObservable().withLatestFrom(input.friendName).subscribe(onNext: {[weak self] name in
            guard let self = self else { return }
            api.findFriends(name).subscribe(onNext: { response in
                print(response)
                switch response {
                case .success:
                    findData.onNext("Complete")
                case .notFound:
                    findData.onNext("ID에 해당하는 유저가 없습니다.")
                default:
                    findData.onNext("추가할 수 없습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(findData: findData.asSignal(onErrorJustReturn: ""))
    }
    
}
