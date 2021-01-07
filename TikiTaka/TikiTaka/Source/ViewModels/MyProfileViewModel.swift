//
//  MyProfileViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation
import RxSwift
import RxCocoa

class MyProfileViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadProfile: Signal<Void>
    }
    
    struct Output {
        let result: Signal<String>
        let laodData: BehaviorRelay<ProfileData?>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let loadData = BehaviorRelay<ProfileData?>(value: nil)
        
        input.loadProfile.asObservable().subscribe(onNext: {_ in
            api.getMyProfile().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    loadData.accept(data!)
                    result.onCompleted()
                default:
                    result.onNext("프로필을 불러 올 수 없습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: "프로필 로드 실패"), laodData: loadData)
    }
}

