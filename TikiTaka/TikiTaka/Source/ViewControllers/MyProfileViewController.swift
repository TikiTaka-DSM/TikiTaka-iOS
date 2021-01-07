//
//  MyProfileViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MyProfileViewController: UIViewController {
    
    private let gearBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        $0.tintColor = PointColor.primary
        $0.imageView?.contentMode = .scaleToFill
    }
    
    private let userImageView = UIImageView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 54.5
    }
    
    private let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 22)
        $0.text = "ID : 기매린"
    }
    
    private let userIDLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .lightGray
        $0.text = "rin1234"
    }
    
    private let statusLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
        $0.text = "취업하고 싶어요"
        $0.underLine()
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyProfileViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(gearBtn)
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userIDLabel)
        view.addSubview(statusLabel)

        bindViewModel()
        setUpConstraint()
    }
    
    func bindViewModel() {
        let input = MyProfileViewModel.Input(loadProfile: loadData.asSignal(onErrorJustReturn: ()))
        let output = viewModel.transform(input: input)
        
        output.result.emit(onNext: { text in
            self.setAlert(text)
        }).disposed(by: disposeBag)
        
        output.laodData.bind{ (data) in
            self.userImageView.kf.setImage(with: URL(string: (data?.profileData.img)!))
            self.userNameLabel.text = data?.profileData.name
            self.statusLabel.text = data?.profileData.statusMessage
        }.disposed(by: disposeBag)
    }

    func setUpConstraint() {
        
        gearBtn.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top).offset(60)
            $0.trailing.equalTo(-30)
            $0.height.width.equalTo(40)
        }
        
        userImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gearBtn.snp.bottom).offset(100)
            $0.height.width.equalTo(109)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userImageView.snp.bottom).offset(16)
        }
        
        userIDLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userNameLabel.snp.bottom).offset(3)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userIDLabel.snp.bottom).offset(20)
        }
    }

}
