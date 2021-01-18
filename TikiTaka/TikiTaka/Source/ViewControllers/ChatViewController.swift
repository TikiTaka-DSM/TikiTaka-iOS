//
//  ChatViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa
import MessageKit
import InputBarAccessoryView

class ChatViewController: UIViewController {

    private let chatTableView = UITableView()
    private let inputBar = ChatInputField()
    
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
