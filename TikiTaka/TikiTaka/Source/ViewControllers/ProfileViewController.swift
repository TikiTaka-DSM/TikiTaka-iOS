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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.image = UIImage(systemName: "camera")
        userImageView.contentMode = .scaleAspectFit
        
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(statusLabel)
        
        setUpConstraint()
    }
    
    func setUpConstraint() {
        
        self.forCornerRadius(userImageView)
        
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
