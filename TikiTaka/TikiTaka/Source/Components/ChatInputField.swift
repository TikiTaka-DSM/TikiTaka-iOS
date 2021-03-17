//
//  ChatInputField.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/17.
//

import UIKit

final class ChatInputField: UIView {

    let chatImg = UIButton().then {
        $0.setImage(UIImage(systemName: "photo"), for: .normal)
        $0.tintColor = .white
    }
    
    let chatAudio = UIButton().then {
        $0.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        $0.tintColor = .white
    }
    
    let inputTextField = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
        $0.returnKeyType = .default
        $0.keyboardDismissMode = .interactive
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    let sendBtn = UIButton().then {
        $0.setTitle("전송", for: .normal)
        $0.isHidden = false
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    let recordTime = UILabel().then {
        $0.textColor = .white
        $0.font = .monospacedSystemFont(ofSize: 10, weight: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputTextField.layer.cornerRadius = 16
        
        backgroundColor = PointColor.primary
        
        addSubview(stackView)
        stackView.addArrangedSubview(chatImg)
        stackView.addArrangedSubview(chatAudio)
        stackView.addArrangedSubview(inputTextField)
        stackView.addArrangedSubview(sendBtn)
        inputTextField.addSubview(recordTime)
        
        recordTime.isHidden = true
        sendBtn.isHidden = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {

        chatImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26)
        }
        
        chatAudio.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26)
        }
        
        inputTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        sendBtn.snp.makeConstraints {
            $0.trailing.equalTo(snp.trailing).offset(-10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
            $0.width.equalTo(35)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(snp.leading).offset(10)
            $0.trailing.equalTo(snp.trailing).offset(-10)
            $0.height.equalTo(26)
            $0.height.greaterThanOrEqualTo(50)
            $0.centerY.equalToSuperview()
        }
        
        recordTime.snp.makeConstraints {
            $0.trailing.equalTo(inputTextField.snp.trailing).offset(-10)
            $0.centerY.equalToSuperview()
            $0.top.equalTo(inputTextField.snp.top).offset(6)
        }
        
        super.updateConstraints()
    }
}

