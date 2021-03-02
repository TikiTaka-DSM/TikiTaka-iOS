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
        let messageImage: Driver<String>
        let messageAudio: Driver<Data>
    }
    
    struct Output {
        let loadData: BehaviorRelay<[CellType]>
        let afterSend: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let api = Service()
        let loadData = BehaviorRelay<[CellType]>(value: [])
        let afterSend = PublishSubject<String>()
        let Textinfo = Driver.combineLatest(Driver.just(input.roomId), input.messageText)
        let Imageinfo = Driver.combineLatest(Driver.just(input.roomId), input.messageImage)
        let Audioinfo = Driver.combineLatest(Driver.just(input.roomId), input.messageText)
        var cellType: [CellType] = []
        let token = TokenManager.currentToken?.tokens.accessToken

        input.loadChat.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            api.getChatInfo(input.roomId).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    for item in 0..<data!.messageData.count {
                        if data!.roomData.name == data!.messageData[item].user.name{
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
            SocketIOManager.shared.sendMessage(id, token!, message: text)
            
            let data = emitMessage(user: SearchUser(id: "gayo03", name: "gayo03", img: ""), message: text, photo: "", voice: "", createdAt: TimeZone.current.identifier)
            
            loadData.add(element: CellType.myMessages(data))
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
        input.messageImage.asObservable().withLatestFrom(Imageinfo).subscribe(onNext: { id, image in
            SocketIOManager.shared.sendImage(id, token!, image: image)
            
            let data = emitMessage(user: SearchUser(id: "gayo03", name: "gayo03", img: ""), message: "", photo: image, voice: "", createdAt: TimeZone.current.identifier)
            
            loadData.add(element: CellType.myMessages(data))
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
        input.messageAudio.asObservable().withLatestFrom(Audioinfo).subscribe(onNext: { id, audio in
            SocketIOManager.shared.sendVoice(id, token!, voice: audio)
            
            let data = emitMessage(user: SearchUser(id: "gayo03", name: "gayo03", img: ""), message: "", photo: "", voice: audio, createdAt: TimeZone.current.identifier)
            
            loadData.add(element: CellType.myMessages(data))
            
            afterSend.onNext("전송완료")
        }).disposed(by: disposeBag)
        
//        socketClient.on("realTimeChatting") { (data, ack) in
//            print(data)
//
//            var name = String()
//            var img = String()
//            var id = String()
//            var message = String()
//            var photo = String()
//            var voice = String()
//            var createdAt = String()
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: data)
//                let decoder = JSONDecoder()
//                let addComments = try decoder.decode(emitMessage.self, from: jsonData)
//
//                name = addComments.user.name
//                id = addComments.user.id
//                img = addComments.user.img
//                message = addComments.message ?? ""
//                photo = addComments.photo ?? ""
//                voice = addComments.voice ?? ""
//                createdAt = addComments.createdAt
//            } catch {
//                print(error)
//            }
//
//            let data = emitMessage(user: SearchUser(id: id, name: name, img: img), message: message , photo: photo, voice: voice, createdAt: createdAt)
//
//            loadData.add(element: CellType.yourMessage(data))
//        }
        
        return Output(loadData: loadData, afterSend: afterSend.asSignal(onErrorJustReturn: ""))
    }
}

enum CellType {
    case yourMessage(emitMessage)
    case myMessages(emitMessage)
}
