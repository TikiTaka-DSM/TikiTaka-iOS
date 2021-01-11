//
//  ChatTableViewCell.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/11.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    let chatImg = UIImageView()
    let chatName = UILabel()
    let chatTime = UILabel()
    let lastMessage = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(chatImg)
        contentView.addSubview(chatName)
        contentView.addSubview(chatTime)
        contentView.addSubview(lastMessage)
        
        chatImg.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(9)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-8)
            $0.width.height.equalTo(53)
            $0.leading.equalTo(contentView.snp.leading).offset(5)
        }
        
        chatName.snp.makeConstraints {
            $0.leading.equalTo(chatImg.snp.trailing).offset(18)
            $0.top.equalTo(chatImg.snp.top)
        }
        
        lastMessage.snp.makeConstraints {
            $0.leading.equalTo(chatImg.snp.trailing).offset(18)
            $0.top.equalTo(chatName.snp.bottom).offset(5)
        }
        
        chatTime.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
