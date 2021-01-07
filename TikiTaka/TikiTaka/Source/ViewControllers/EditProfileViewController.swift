//
//  EditProfileViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/06.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: UIViewController {

    private let editBtn = UIButton().then {
        $0.backgroundColor = PointColor.primary
        $0.tintColor = .white
        $0.layer.cornerRadius = 52.5
        $0.setTitle("변경하기", for: .normal)
    }
    
    private let userImageBtn = UIButton().then {
        $0.backgroundColor = .black
        $0.alpha = 0.7
        $0.layer.cornerRadius = 54.5
    }
    
    private let nameTextField = UITextField().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private let statusTextField = UITextField().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
        $0.text = "취업하고 싶어요"
    }
    
    private let defaultImg = UIImageView().then {
        $0.image = UIImage(systemName: "camera")
        $0.tintColor = .white
    }
  
    private let disposeBag = DisposeBag()
    private let viewModel = EditProfileViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    private let editImageData = PublishRelay<Data?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(editBtn)
        view.addSubview(userImageBtn)
        view.addSubview(nameTextField)
        view.addSubview(statusTextField)
        view.insertSubview(defaultImg, aboveSubview: userImageBtn)
        
        bindViewModel()
        setUpConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        nameTextField.underLine()
        statusTextField.underLine()
    }
    
    func bindViewModel() {
        let input = EditProfileViewModel.Input(
            loadProfile: loadData.asSignal(onErrorJustReturn: ()),
            editImage: editImageData.asDriver(onErrorJustReturn: nil),
            editName:nameTextField.rx.text.orEmpty.asDriver(),
            editStatus: statusTextField.rx.text.orEmpty.asDriver(),
            doneTap: editBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.laodData.bind{ (data) in
            self.userImageBtn.imageView!.kf.setImage(with: URL(string: (data?.profileData.img)!))
            self.nameTextField.text = data?.profileData.name
            self.statusTextField.text = data?.profileData.statusMessage
        }.disposed(by: disposeBag)
        
        output.result.emit(onNext: { text in
            self.setAlert(text)
        }).disposed(by: disposeBag)
        
        output.edit.emit(onNext: { text in
            self.setAlert(text)
        }, onCompleted: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setUpConstraint() {
        
        editBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
            $0.top.equalTo(statusTextField.snp.bottom).offset(100)
        }
        
        userImageBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(200)
            $0.height.width.equalTo(109)
        }
        
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.top.equalTo(userImageBtn.snp.bottom).offset(16)
        }
        
        statusTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(30)
            $0.width.equalTo(180)
        }
        
        defaultImg.snp.makeConstraints {
            $0.center.equalTo(userImageBtn)
            $0.width.height.equalTo(30)
        }
        
    }


}
