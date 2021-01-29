//
//  MainViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/29.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadChatList: Signal<Void>
        let selectRoom: Signal<IndexPath>
    }
    
    struct Output {
        let loadData: Driver<[ChatListSection]>
        let selectData: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = BehaviorRelay<[ChatListSection]>(value: [])
        let selectData = PublishRelay<Int>()
        
        input.loadChatList.asObservable().subscribe(onNext: { _ in
            api.getChatList().subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .success:
                    var result = [String : [ChatList]]()
                    for i in 0..<data!.count {
                        if result[String(i)] == nil {
                            result[String(i)] = data!
                            continue
                        }
                        result[String(i)]?.append(data![i])
                    }
                    
                    loadData.accept(result.compactMap { ChatListSection(model: $0.key, items: $0.value) })
                    print(result)
                default:
                    print("asdf")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.selectRoom.asObservable().subscribe(onNext: { indexPath in
            let room = loadData.value
            selectData.accept(room[indexPath.row].items[indexPath.row].roomId)
        }).disposed(by: disposeBag)

        return Output(loadData: loadData.asDriver(), selectData: selectData.asDriver(onErrorJustReturn: 0))
    }


}
