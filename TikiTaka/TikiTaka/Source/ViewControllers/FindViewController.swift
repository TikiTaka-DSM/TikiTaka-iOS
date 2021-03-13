//
//  FindViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/09.
//

import UIKit
import RxSwift
import RxCocoa

final class FindViewController: UIViewController {

    // MARK: UI
    
    private let searchBar = SearchBar().then {
        $0.backgroundColor = PointColor.primary
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = PointColor.primary
        $0.text = "검색을 통해 친구를 찾아보세요!"
        $0.numberOfLines = 0
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = FindViewModel()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchBar)
        view.addSubview(errorLabel)
        
        bindViewModel()
        
        navigationBarColor(.white)
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpConstraint()
    }
    
    // MARK: Binding
    
    private func bindViewModel() {
        let input = FindViewModel.Input(friendName: searchBar.searchTextField.rx.text.orEmpty.asDriver(),
                                        findFriend: searchBar.doneBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.findData.emit(onNext: {[unowned self] error in errorLabel.text = error },
                             onCompleted: {[unowned self] in
                                guard let vc = storyboard?.instantiateViewController(identifier: "Profile") as? ProfileViewController else { return }
                                vc.friendId = searchBar.searchTextField.text!
                                present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    // MARK: Constraint
    private func setUpConstraint() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
