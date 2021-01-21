//
//  ChatViewModel.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import SocketIO

final class ChatViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let roomId: Int
        let loadChat: Signal<Void>
        let emitText: Driver<Void>
        let messageText: Driver<String>
    }
    
    struct Output {
        let loadData: PublishRelay<[CellType]>
        let afterSend: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = PublishRelay<[CellType]>()
        let afterSend = PublishSubject<String>()
        let info = Driver.combineLatest(Driver.just(input.roomId), input.messageText)
        var cellType: [CellType] = []
        var socketClient: SocketIOClient!
        
        input.loadChat.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            api.getChatInfo(input.roomId).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    for item in 0..<data!.messageData.count {
                        if data!.roomData.roomData.name == data!.messageData[item].user.name{
                            cellType.append(.yourMessage(data!.messageData[item]))
                        }else {
                            cellType.append(.myMessages(data!.messageData[item]))
                        }
                    }
                    loadData.accept(cellType)
                default:
                    print("af")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.emitText.asObservable().withLatestFrom(info).subscribe(onNext: { id, text in
            socketClient.emit("chatting", ["roomId": id, "token": Token.self, "message": text])
            
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
        return Output(loadData: loadData, afterSend: afterSend.asSignal(onErrorJustReturn: ""))
    }
}

enum CellType {
    case yourMessage(Message)
    case myMessages(Message)
}
