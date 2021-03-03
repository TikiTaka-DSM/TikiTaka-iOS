//
//  ProfileViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    // MARK: UI
    
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 22)
    }
    private let statusLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
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
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    var friendId = String()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.contentMode = .scaleAspectFit
        
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(statusLabel)
        view.addSubview(chatBtn)
        view.addSubview(blockBtn)
        view.addSubview(addBtn)
        
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        statusLabel.underLine()
        forCornerRadius(userImageView)
        forCornerRadius(chatBtn)
        forCornerRadius(blockBtn)
        setUpConstraint()
        forCornerRadius(addBtn)
    }
    
    // MARK: Binding
    
    private func bindViewModel() {
        let input = ProfileViewModel.Input(loadProfile: loadData.asSignal(onErrorJustReturn: ()),
                                           friendId: friendId,
                                           selectAdd: addBtn.rx.tap.asDriver(),
                                           selectChat: chatBtn.rx.tap.asDriver(),
                                           selectBlock: blockBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.loadData.bind {[unowned self] (data) in
            userImageView.kf.setImage(with: URL(string: "https://jobits.s3.ap-northeast-2.amazonaws.com/\(data.profileData.img)"))
            userNameLabel.text = data.profileData.name
            statusLabel.text = data.profileData.statusMessage
        }.disposed(by: disposeBag)
        
        output.postChat.emit(onNext: {[unowned self] data in
            guard let vc  = storyboard?.instantiateViewController(identifier: "Chat") as? ChatViewController else { return }
            vc.roomId = data!.roomData.id
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        output.postBlock.emit(onCompleted: { [unowned self] in dismiss(animated: true, completion: nil)}).disposed(by: disposeBag)
    }
    
    // MARK: Constraint
    
    private func setUpConstraint() {
   
        userImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(75)
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

}
