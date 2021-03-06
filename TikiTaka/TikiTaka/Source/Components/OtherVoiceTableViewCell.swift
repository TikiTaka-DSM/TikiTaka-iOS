//
//  OtherVoiceTableViewCell.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/24.
//

import UIKit
import RxSwift

class OtherVoiceTableViewCell: UITableViewCell {
    
    let timeLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "0:00"
    }
    
    let playBtn = UIButton().then {
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "play.fill"), for: .normal)
        $0.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        $0.isSelected = true
    }
    
    let bubbleView = UIImageView().then {
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 10
    }
    
    let userImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "TikiTaka_logo")
        $0.layer.cornerRadius = 26.5
        $0.layer.borderWidth = 0.1
        $0.layer.borderColor = UIColor.gray.cgColor
    }
    
    let cellDisposeBag = DisposeBag()
    private var timer: Timer?
    private var count = Int()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleView)
        addSubview(userImageView)
        addSubview(timeLabel)
        addSubview(playBtn)
        
        
        selectionStyle = .none
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(playBtn.snp.trailing).offset(8)
        }
        
        playBtn.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
        }
        
        bubbleView.snp.makeConstraints {
            $0.top.equalTo(playBtn.snp.top).offset(-8)
            $0.bottom.equalTo(timeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(playBtn.snp.leading).offset(-8)
            $0.trailing.equalTo(timeLabel.snp.trailing).offset(8)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(16)
            $0.bottom.equalTo(snp.bottom).offset(-16)
            $0.leading.equalTo(snp.leading).offset(11)
            $0.width.height.equalTo(53)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @objc func counting() {
        count += 1
        
        let minutes = count / 60 % 60
        let seconds = count % 60
        
        timeLabel.text = String(format: "%01i:%02i", minutes, seconds)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if playBtn.isSelected {
            timer?.invalidate()
            playBtn.isSelected = !playBtn.isSelected
        }else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counting), userInfo: nil, repeats: true)
            playBtn.isSelected = !playBtn.isSelected
        }
    }
    
}
