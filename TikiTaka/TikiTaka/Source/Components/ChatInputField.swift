//
//  ChatInputField.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/17.
//

import UIKit

class ChatInputField: UIView {

    let chatImg = UIButton().then {
        $0.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        $0.tintColor = .white
    }
    
    let chatAudio = UIButton().then {
        $0.setImage(UIImage(systemName: "photo"), for: .normal)
        $0.tintColor = .white
    }
    
    let inputTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.addLeftPadding()
    }
    
    let sendBtn = UIButton().then {
        $0.setTitle("전송", for: .normal)
    }
    
    let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inputTextField.layer.cornerRadius = 20
        
        self.backgroundColor = PointColor.primary
        
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(chatImg)
        stackView.addArrangedSubview(chatAudio)
        stackView.addArrangedSubview(inputTextField)
        stackView.addArrangedSubview(sendBtn)
        
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
        }
        
        sendBtn.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
            $0.height.equalTo(26)
            $0.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
