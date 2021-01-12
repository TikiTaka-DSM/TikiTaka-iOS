//
//  ProfileViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import UIKit

class ProfileViewController: UIViewController {

    private let userImageView = UIImageView()
    private let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 22)
        $0.text = "백예린"
    }
    private let statusLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
        $0.text = "요즘 DPR 노래가 좋더라~!"
    }
    
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
    private var isFriend: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.image = UIImage(systemName: "camera")
        userImageView.contentMode = .scaleAspectFit
        
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(statusLabel)
        view.addSubview(chatBtn)
        view.addSubview(blockBtn)
        view.addSubview(addBtn)
        
        setUpConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        statusLabel.underLine()
        self.forCornerRadius(userImageView)
        self.forCornerRadius(chatBtn)
        self.forCornerRadius(blockBtn)
        self.forCornerRadius(addBtn)
    }
    
    func setUpConstraint() {
   
        userImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.snp.top).offset(75)
            $0.height.width.equalTo(140)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userImageView.snp.bottom).offset(25)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userNameLabel.snp.bottom).offset(16)
        }
        
        if isFriend {
            addBtn.isHidden = true
            
            chatBtn.snp.makeConstraints {
                $0.height.width.equalTo(90)
                $0.leading.equalToSuperview().offset(75)
                $0.top.equalTo(statusLabel.snp.bottom).offset(120)
            }
            
            blockBtn.snp.makeConstraints {
                $0.height.width.equalTo(90)
                $0.trailing.equalToSuperview().offset(-75)
                $0.top.equalTo(statusLabel.snp.bottom).offset(120)
            }
            
        } else {
            chatBtn.isHidden = true
            blockBtn.isHidden = true
            
            
            addBtn.snp.makeConstraints {
                $0.height.width.equalTo(105)
                $0.top.equalTo(statusLabel.snp.bottom).offset(120)
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
