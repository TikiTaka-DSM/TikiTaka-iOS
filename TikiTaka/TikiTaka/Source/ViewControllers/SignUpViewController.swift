//
//  SignUpViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let logoView = UIImageView().then {
        $0.image = UIImage(named: "TikiTaka_logo")
    }
    
    let logoLabel = UILabel().then {
        $0.text = "지금 바로 티키타카에 가입해 보세요!"
        $0.textColor = PointColor.sub
    }
    
    let idTextField = UITextField().then {
        $0.placeholder = "ID"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
        $0.addLeftPadding()
    }
    
    let pwTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
        $0.addLeftPadding()
        $0.isSecureTextEntry = true
    }
    
    let nameTextField = UITextField().then {
        $0.placeholder = "이름"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
        $0.addLeftPadding()
    }
    
    let RepwTextField = UITextField().then {
        $0.placeholder = "Password check"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
        $0.addLeftPadding()
        $0.isSecureTextEntry = true
    }
    
    let signInBtn = UIButton().then {
        $0.clipsToBounds = true
        $0.setBackgroundColor(PointColor.enable, for: .disabled)
        $0.setBackgroundColor(PointColor.sub, for: .normal)
        $0.setTitle("Sign up", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 28
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoView)
        view.addSubview(logoLabel)
        view.addSubview(idTextField)
        view.addSubview(pwTextField)
        view.addSubview(signInBtn)
        view.addSubview(nameTextField)
        view.addSubview(RepwTextField)

        setUpConstraint()
        bindViewModel()
    }

    func bindViewModel() {
        let input = SignUpViewModel.Input(id: idTextField.rx.text.orEmpty.asDriver(), name: nameTextField.rx.text.orEmpty.asDriver(), password: pwTextField.rx.text.orEmpty.asDriver(), repassword: RepwTextField.rx.text.orEmpty.asDriver(), doneTap: signInBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.result.emit(onNext: { text in
            self.setAlert(text)
        },onCompleted: { self.pushVC("Main") }).disposed(by: disposeBag)
        output.isEnable.drive(self.signInBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnable.drive(onNext: { isEnable in
            self.signInBtn.tintColor = UIColor.gray
        }).disposed(by: disposeBag)
    }
    
    func setUpConstraint() {
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
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
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
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoLabel.snp.bottom).offset(15)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        RepwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.leading.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(RepwTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.centerX.equalTo(view)
        }
    }


}
