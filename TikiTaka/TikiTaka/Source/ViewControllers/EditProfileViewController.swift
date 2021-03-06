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

    // MARK: UI
    
    private let editBtn = UIButton().then {
        $0.backgroundColor = PointColor.primary
        $0.tintColor = .white
        $0.layer.cornerRadius = 52.5
        $0.setTitle("변경하기", for: .normal)
    }
    
    private let userImageBtn = UIButton().then {
        $0.alpha = 0.7
        $0.imageView?.layer.cornerRadius = 54.5
        
    }
    
    private let nameTextField = UITextField().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private let statusTextField = UITextField().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    
    private let defaultImg = UIImageView().then {
        $0.image = UIImage(systemName: "camera")
        $0.tintColor = .white
    }
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = EditProfileViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    private let editImageData = BehaviorRelay<Data?>(value: nil)
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(editBtn)
        view.addSubview(userImageBtn)
        view.addSubview(nameTextField)
        view.addSubview(statusTextField)
        view.insertSubview(defaultImg, aboveSubview: userImageBtn)
        
        userImageBtn.rx.tap.subscribe(onNext: {[unowned self] in present(imagePicker, animated: true, completion: nil)}).disposed(by: disposeBag)
        
        bindViewModel()
        setUpConstraint()
        
        editImageData.accept(userImageBtn.currentImage?.jpegData(compressionQuality: 0.2))
        
        navigationBarColor(PointColor.primary)
        UIApplication.shared.statusBarUIView?.backgroundColor = PointColor.primary
    }
    
    override func viewDidLayoutSubviews() {
        nameTextField.underLine()
        statusTextField.underLine()
    }
    
    // MARK: Binding
    
    private func bindViewModel() {
        let input = EditProfileViewModel.Input(loadProfile: loadData.asSignal(onErrorJustReturn: ()),
                                               editImage: editImageData.asDriver(onErrorJustReturn: nil),
                                               editName: nameTextField.rx.text.orEmpty.asDriver(),
                                               editStatus: statusTextField.rx.text.orEmpty.asDriver(),
                                               doneTap: editBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.laodData.asObservable().subscribe(onNext: { [unowned self] data in
            userImageBtn.kf.setImage(with: URL(string: "https://jobits.s3.ap-northeast-2.amazonaws.com/\(data?.profileData.img ?? "default.png")"), for: .normal)
            nameTextField.text = data?.profileData.name
            statusTextField.text = data?.profileData.statusMessage
        }).disposed(by: disposeBag)
        
        output.result.emit(onNext: {[unowned self] text in setAlert(text) }).disposed(by: disposeBag)
        output.edit.emit(onNext: {[unowned self] text in setAlert(text) },
                         onCompleted: {[unowned self] in navigationController?.popViewController(animated: true)}).disposed(by: disposeBag)
    }
    
    // MARK: Constraint
    
    private func setUpConstraint() {
        
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            guard let imageData = originalImage.jpegData(compressionQuality: 0.4) else { return }
            userImageBtn.setImage(originalImage, for: .normal)
            editImageData.accept(imageData)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
