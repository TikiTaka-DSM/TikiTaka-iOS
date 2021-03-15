//
//  ProfileViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/05.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationBarColor(.clear)
        navigationController?.navigationBar.tintColor = PointColor.primary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationBarColor(.clear)
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = PointColor.primary
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
            isBlocked(data.state.block, data.state.friend)
            userImageView.kf.setImage(with: URL(string: "https://jobits.s3.ap-northeast-2.amazonaws.com/\(data.profileData.img)"))
            userNameLabel.text = data.profileData.name
            statusLabel.text = data.profileData.statusMessage
        }.disposed(by: disposeBag)
        
        output.postChat.emit(onNext: {[unowned self] data in
            dismiss(animated: true) {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Chat")
                    as? ChatViewController else { return }
                vc.roomId = data!.roomData.id
                navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        output.postBlock.emit(onCompleted: { [unowned self] in dismiss(animated: true, completion: nil)}).disposed(by: disposeBag)
        
        output.postFriend.emit(onNext: { [unowned self] error in setAlert(error)} ,
                               onCompleted: { [unowned self] in dismiss(animated: true, completion: nil)}).disposed(by: disposeBag)
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
        
    }
    
    func isBlocked(_ block: Bool, _ friend: Bool) {
        if block {
            chatBtn.isHidden = true
            addBtn.isHidden = true
            blockBtn.setTitle("차단해제", for: .normal)

            blockBtn.snp.makeConstraints {
                $0.height.width.equalTo(105)
                $0.top.equalTo(statusLabel.snp.bottom).offset(120)
                $0.centerX.equalToSuperview()
            }
        }else if friend {
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
