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
        let messageImage: Driver<Data>
        let messageAudio: Driver<Data>
    }
    
    struct Output {
        let loadData: PublishRelay<[CellType]>
        let afterSend: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = PublishRelay<[CellType]>()
        let afterSend = PublishSubject<String>()
        let Textinfo = Driver.combineLatest(Driver.just(input.roomId), input.messageText)
        let Imageinfo = Driver.combineLatest(Driver.just(input.roomId), input.messageText)
        let Audioinfo = Driver.combineLatest(Driver.just(input.roomId), input.messageText)
        var cellType: [CellType] = []
        var socketClient: SocketIOClient!
        let token = TokenManager.currentToken?.accessToken
        
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
        
        input.emitText.asObservable().withLatestFrom(Textinfo).subscribe(onNext: { id, text in
            socketClient.emit("chatting", ["roomId": id, "token": token, "message": text])
            
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
        input.messageImage.asObservable().withLatestFrom(Imageinfo).subscribe(onNext: { id, image in
            socketClient.emit("chatting", ["roomId": id, "token": token, "image": image])
            
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
        input.messageAudio.asObservable().withLatestFrom(Audioinfo).subscribe(onNext: { id, audio in
            socketClient.emit("chatting", ["roomId": id, "token": token, "voice": audio])
            
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
        socketClient.on("realTimeChatting") { (data, ack) in
//            let name = data[2] as! String
//            let message = data[3] as! String
//            let profileImg = data[1] as! String
//
//            output.loadChat.add(element: chat)
        }
        
        return Output(loadData: loadData, afterSend: afterSend.asSignal(onErrorJustReturn: ""))
    }
}

enum CellType {
    case yourMessage(Message)
    case myMessages(Message)
}
