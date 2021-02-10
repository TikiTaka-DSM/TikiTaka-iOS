//
//  ChatViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import SocketIO
import Kingfisher

class ChatViewController: UIViewController {
    
    private let chatTableView = UITableView()
    private let inputBar = ChatInputField()
    private let disposeBag = DisposeBag()
    private let viewModel = ChatViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    private let sendImage = PublishRelay<Data>()
    private let sendVoice = PublishRelay<Data>()
    private var voiceRecord: AVAudioRecorder!
    private var timer = Timer()
    private var count = Int()
    var socketClient: SocketIOClient!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    var roomId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chatTableView)
        view.addSubview(inputBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(note:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(note:)), name: UIResponder.keyboardWillHideNotification , object: nil)
        
        inputBar.inputTextField.delegate = self
        setTableView()
        setUpConstraint()
        bindViewModel()
        
        SocketIOManager.shared.establishConnection()
        socketClient = SocketIOManager.shared.socket
        SocketIOManager.shared.socket.emit("joinRoom", ["roodId": roomId])
        
        inputBar.chatAudio.rx.tap.subscribe(onNext: { _ in
            self.setRecord()
        }).disposed(by: disposeBag)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chatTableView.separatorColor = .clear
        chatTableView.separatorInset = .zero
        chatTableView.separatorStyle = .none
    }
    
    func bindViewModel() {
        
        let input = ChatViewModel.Input(roomId: roomId, loadChat: loadData.asSignal(onErrorJustReturn: ()), emitText: inputBar.sendBtn.rx.tap.asDriver(), messageText: inputBar.inputTextField.rx.text.orEmpty.asDriver(), messageImage: sendImage.asDriver(onErrorJustReturn: Data.init()), messageAudio: sendVoice.asDriver(onErrorJustReturn: Data.init()))
        let output = viewModel.transform(input: input)

        output.loadData.asObservable().bind(to: chatTableView.rx.items) { tableview, row, cellType -> UITableViewCell in
            switch cellType {
            case .myMessages(let message):
                print(message)
                if message.message!.isEmpty && message.photo!.isEmpty{
                    //voice
                    let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "myVoiceCell") as! MyVoiceTableViewCell


                    return cell
                }else if message.photo!.isEmpty {
                    //message
                    let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "mineCell") as! MyTableViewCell

                    cell.messageLabel.text = message.message

                    return cell
                }else {
                    //photo
                    let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "mineCell") as! MyTableViewCell

                    cell.bubbleView.kf.setImage(with: URL(string: ""))

                    return cell
                }
            case .yourMessage(let message):
                print(message)
                if message.message!.isEmpty && message.photo!.isEmpty{
                    //voice
                    let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "otherVoiceCell") as! OtherVoiceTableViewCell
                    
                    cell.userImageView.kf.setImage(with: URL(string: ""))
                    
                    return cell
                }else if message.photo!.isEmpty {
                    //message
                    let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "otherCell") as! OtherTableViewCell

                    cell.messageLabel.text = message.message
                    cell.userImageView.kf.setImage(with: URL(string: ""))
                    
                    return cell
                }else {
                    //photo
                    let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "otherCell") as! OtherTableViewCell

                    cell.bubbleView.kf.setImage(with: URL(string: ""))
                    cell.userImageView.kf.setImage(with: URL(string: ""))
                    
                    return cell
                }
            }
        }.disposed(by: disposeBag)
        
        output.afterSend.emit(onNext: {[unowned self] _ in
            print("굳")
            loadData.accept(())
            chatTableView.reloadData()
//
        }).disposed(by: disposeBag)
    }
    
    func setTableView() {
        chatTableView.register(MyTableViewCell.self, forCellReuseIdentifier: "mineCell")
        chatTableView.register(OtherTableViewCell.self, forCellReuseIdentifier: "otherCell")
        chatTableView.register(OtherVoiceTableViewCell.self, forCellReuseIdentifier: "otherVoiceCell")
        chatTableView.register(MyVoiceTableViewCell.self, forCellReuseIdentifier: "myVoiceCell")
    }
    
    func setRecord() {
        UIView.animate(withDuration: 0.5) { [unowned self] in
            inputBar.chatAudio.isSelected = !inputBar.chatAudio.isSelected
            inputBar.chatImg.isHidden = !inputBar.chatImg.isHidden
            inputBar.inputTextField.isEnabled = !inputBar.inputTextField.isEnabled
            inputBar.recordTime.isHidden = !inputBar.recordTime.isHidden
            if inputBar.chatAudio.isSelected {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counting), userInfo: nil, repeats: true)
                inputBar.sendBtn.isHidden = true
                inputBar.inputTextField.text = "녹음을 끝내려면 아이콘을 클릭해주세요."
                inputBar.inputTextField.backgroundColor = PointColor.sub
                inputBar.inputTextField.textColor = .white
                inputBar.chatAudio.tintColor = PointColor.sub
                startRecording()
            } else {
                timer.invalidate()
                inputBar.sendBtn.isHidden = false
                inputBar.inputTextField.text = ""
                inputBar.inputTextField.backgroundColor = .white
                inputBar.inputTextField.textColor = .black
                inputBar.chatAudio.tintColor = .white
                voiceRecord.stop()
            }
        }
    }
    
    func startRecording() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFileName = paths[0].appendingPathComponent(NSUUID().uuidString + ".m4a")
        
        let settings = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            voiceRecord = try AVAudioRecorder(url: audioFileName, settings: settings)
            voiceRecord.delegate = self
            voiceRecord.record()
        }catch {
            voiceRecord.stop()
            voiceRecord = nil
        }
    }
    
    func setUpConstraint() {
        chatTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        inputBar.snp.makeConstraints {
            $0.top.equalTo(chatTableView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(41)
        }
    }
    
    @objc func keyboardWillAppear(note: Notification){
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
            inputBar.sendBtn.isHidden = false
        }
    }
    
    @objc func keyboardWillDisappear(note: Notification){
        self.view.frame.origin.y = 0
        inputBar.sendBtn.isHidden = true
    }
    
    @objc func counting() {
        count += 1
        
        let minutes = count / 60 % 60
        let seconds = count % 60
        
        inputBar.recordTime.text = String(format: "%01i:%02i", minutes, seconds)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            guard let imageData = originalImage.jpegData(compressionQuality: 0.4) else {
                print("Could not get JPEG representation of UIImage")
                return
            }
            sendImage.accept(imageData)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        do {
            
            let data = try Data(contentsOf: voiceRecord.url)
            sendVoice.accept(data.base64EncodedData())
        }catch {
            print(error)
        }
    }
}
