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
        setUpConstraint()
    }
      
    override func viewWillAppear(_ animated: Bool) {
        chatTableView.separatorColor = .clear
        chatTableView.separatorInset = .zero
        chatTableView.separatorStyle = .none
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
            $0.height.equalTo(40)
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
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
