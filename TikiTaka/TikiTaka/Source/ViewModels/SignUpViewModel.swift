//
//  SignUpViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let id: Driver<String>
        let name: Driver<String>
        let password: Driver<String>
        let repassword: Driver<String>
        let doneTap: Driver<Void>
    }
    
    struct Output {
        let result: Signal<String>
        let isEnable: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.id, input.name, input.password, input.repassword)
        let isEnable = info.map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }
        
        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: { id, name, pw, repw in
            api.signUp(id, repw, name).subscribe(onNext: { response in
                switch response {
                case .success:
                    result.onCompleted()
                case .duplication:
                    result.onNext("중복된 아이디입니다.")
                default:
                    result.onNext("오류로 회원가입에 실패하였습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: "회원가입 실패"), isEnable: isEnable.asDriver())
    }

}
