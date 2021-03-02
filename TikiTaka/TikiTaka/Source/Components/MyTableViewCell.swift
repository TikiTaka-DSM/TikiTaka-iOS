//
//  OtherTableViewCell.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    let messageLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }
        
    let bubbleView = UIImageView().then {
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 10
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleView)
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 0
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(16)
            $0.bottom.equalTo(snp.bottom).offset(-16)
            $0.trailing.equalTo(snp.trailing).offset(-11)
            $0.width.lessThanOrEqualTo(250)
        }
        
        bubbleView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.top).offset(-8)
            $0.bottom.equalTo(messageLabel.snp.bottom).offset(8)
            $0.leading.equalTo(messageLabel.snp.leading).offset(-8)
            $0.trailing.equalTo(messageLabel.snp.trailing).offset(8)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
