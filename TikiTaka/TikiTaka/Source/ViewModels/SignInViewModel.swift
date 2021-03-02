//
//  SignInViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let id: Driver<String>
        let password: Driver<String>
        let doneTap: Driver<Void>
    }
    
    struct Output {
        let result: Signal<String>
        let isEnable: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.id, input.password)
        let isEnable = info.map { !$0.0.isEmpty && !$0.1.isEmpty }
        
        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: {[weak self] id, pw in
            guard let self = self else { return }
            api.signIn(id, pw).subscribe(onNext: { response in
                switch response {
                case .success:
                    result.onCompleted()
                case .notFound:
                    result.onNext("아이디 또는 비밀번호가 잘못되었습니다.")
                default:
                    result.onNext("오류로 로그인이 작동하지 않습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: "로그인 실패"), isEnable: isEnable.asDriver())
    }
}
