//
//  ViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2020/12/14.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit

final class SignInViewController: UIViewController {
    
    // MARK: UI
    
    private let logoView = UIImageView().then {
        $0.image = UIImage(named: "TikiTaka_logo")
    }
    
    private let logoLabel = UILabel().then {
        $0.text = "티키타카를 통해 다양한 사람들과 대화를 해 보세요!"
        $0.textColor = PointColor.sub
    }
    
    private let idTextField = UITextField().then {
        $0.placeholder = "ID"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
        $0.addLeftPadding()
    }
    
    private let pwTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
        $0.addLeftPadding()
        $0.isSecureTextEntry = true
    }
    
    private let signInBtn = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28
        $0.setBackgroundColor(PointColor.enable, for: .disabled)
        $0.setBackgroundColor(PointColor.sub, for: .normal)
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let signUpBtn = UIButton().then {
        $0.setTitle("계정이 없으신가요?", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Arial Hebrew", size: 13)
    }
    
    var disposeBag = DisposeBag()
    private let viewModel = SignInViewModel()
    private var sub = PublishRelay<Void>()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoView)
        view.addSubview(logoLabel)
        view.addSubview(idTextField)
        view.addSubview(pwTextField)
        view.addSubview(signInBtn)
        view.addSubview(signUpBtn)
        
        setupConstraint()
        bindViewModel()
        
        signUpBtn.rx.tap.subscribe(onNext: {[unowned self] _ in pushVC("SignUp") }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Binding
    
    private func bindViewModel() {
        let input = SignInViewModel.Input(id: idTextField.rx.text.orEmpty.asDriver(),
                                          password: pwTextField.rx.text.orEmpty.asDriver(),
                                          doneTap: signInBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.result.emit(onNext: {[unowned self] text in setAlert(text)},
                           onCompleted: {[unowned self] in pushVC("Main") }).disposed(by: disposeBag)
        output.isEnable.drive(signInBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
    // MARK: Constraints
    
    private func setupConstraint() {
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view.frame.height / 8)
            make.width.height.equalTo(110)
        }
        
        logoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoView.snp.bottom).offset(16)
            make.centerX.equalTo(view)
            make.height.equalTo(15)
        }
        
        idTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoLabel.snp.bottom).offset(52)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        pwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.leading.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.centerX.equalTo(view)
        }
        
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signInBtn.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
    }
}

