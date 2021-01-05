//
//  SignUpViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import UIKit

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
    }
    
    let pwTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
    }
    
    let nameTextField = UITextField().then {
        $0.placeholder = "이름"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
    }
    
    let RepwTextField = UITextField().then {
        $0.placeholder = "Password check"
        $0.textColor = .white
        $0.backgroundColor = PointColor.primary
        $0.layer.cornerRadius = 28
    }
    
    let signInBtn = UIButton().then {
        $0.backgroundColor = PointColor.sub
        $0.setTitle("Sign up", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 28
    }
    
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
    }

    func setUpConstraint() {
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(130)
            make.width.height.equalTo(110)
        }
        
        logoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoView.snp.bottom).offset(16)
            make.centerX.equalTo(self.view)
            make.height.equalTo(15)
        }
        
        idTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        pwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        RepwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(RepwTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.centerX.equalTo(self.view)
        }
    }


}
