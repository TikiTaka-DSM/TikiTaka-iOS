//
//  FriendTableViewCell.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/29.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    let friendImg = UIImageView()
    let friendName = UILabel()
    let footerView = UIView().then {
        $0.backgroundColor = PointColor.primary
    }
    let bottomView = UIView().then {
        $0.backgroundColor = PointColor.primary
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(friendImg)
        self.addSubview(friendName)
        self.addSubview(footerView)
        self.addSubview(bottomView)
        
        friendImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
            $0.leading.equalTo(self.snp.leading).offset(5)
        }
        
        friendName.snp.makeConstraints {
            $0.leading.equalTo(friendImg.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
        }
        
        footerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(self.snp.width)
            $0.centerX.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(self.snp.width)
            $0.centerX.equalToSuperview()
        }

        friendImg.layer.cornerRadius = 25
        friendImg.clipsToBounds = true
        
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