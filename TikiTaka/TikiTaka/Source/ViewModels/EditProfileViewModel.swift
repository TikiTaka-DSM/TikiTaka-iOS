//
//  EditProfileViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/07.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let loadProfile: Signal<Void>
        let editImage: Driver<Data?>
        let editName: Driver<String>
        let editStatus: Driver<String>
        let doneTap: Driver<Void>
    }
    
    struct Output {
        let result: Signal<String>
        let laodData: BehaviorRelay<ProfileData?>
        let edit: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let edit = PublishSubject<String>()
        let loadData = BehaviorRelay<ProfileData?>(value: nil)
        let info = Driver.combineLatest(input.editImage, input.editName, input.editStatus)
        
        
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
        
        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: { img, name, status in
            api.changeProfile(img, name, statusMessage: status).response { (response) in
                switch response.response?.statusCode {
                case 200:
                    edit.onCompleted()
                default:
                    edit.onNext("프로필 수정에 실패하였습니다.")
                }
            }
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: "프로필 로드 실패"), laodData: loadData, edit: edit.asSignal(onErrorJustReturn: "프로필 변경 실패"))
    }
}
