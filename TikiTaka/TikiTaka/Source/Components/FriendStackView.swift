//
//  FriendStackView.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import UIKit

class FriendStackView: UIStackView {
    
    var isFriend = Bool()
    
    private let chatBtn = UIButton().then {
        $0.setTitle("채팅하기", for: .normal)
        $0.backgroundColor = PointColor.primary
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let blockBtn = UIButton().then {
        $0.setTitle("차단", for: .normal)
        $0.backgroundColor = PointColor.primary
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let addBtn = UIButton().then {
        $0.setTitle("친구 추가", for: .normal)
        $0.backgroundColor = PointColor.primary
        $0.setTitleColor(.white, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(chatBtn)
        self.addSubview(blockBtn)
        self.addSubview(addBtn)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if isFriend {
            addBtn.isHidden = true
            
            chatBtn.snp.makeConstraints {
                $0.height.width.equalTo(90)
                $0.top.equalToSuperview()
            }
            
            blockBtn.snp.makeConstraints {
                $0.height.width.equalTo(90)
                $0.leading.equalTo(chatBtn.snp.trailing).offset(40)
                $0.top.equalToSuperview()
            }
        } else {
            chatBtn.isHidden = true
            blockBtn.isHidden = true
            
            blockBtn.snp.makeConstraints {
                $0.height.width.equalTo(105)
                $0.top.equalToSuperview()
                $0.center.equalToSuperview()
            }
        }
    }
}
