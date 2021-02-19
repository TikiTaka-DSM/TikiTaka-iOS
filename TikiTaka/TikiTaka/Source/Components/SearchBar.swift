//
//  SearchBar.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import Foundation
import UIKit

class SearchBar: UIView {
    
    let searchTextField = UITextField().then {
        $0.placeholder = "Search"
        $0.textColor = .white
        $0.backgroundColor = .clear
    }
    
    let doneBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 28
        self.backgroundColor = PointColor.primary
        
        self.addSubview(searchTextField)
        self.addSubview(doneBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        doneBtn.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
}
