//
//  MainViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa


final class FriendViewController: UIViewController {

    // MARK: UI
    
    private let friendsTableView = UITableView().then {
        $0.rowHeight = 65
    }

    private let searchBar = SearchBar().then {
        $0.backgroundColor = PointColor.primary
    }

    private let disposeBag = DisposeBag()
    private let loadData = BehaviorRelay<Void>(value: ())
    private let viewModel = FriendViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(friendsTableView)
        view.addSubview(searchBar)
        
        friendsTableView.delegate = self
        
        setTableView()
        bindViewModel()
        setupConstraint()
        
        navigationBarColor(.white)
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
    }
    
    // MARK: LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        friendsTableView.separatorColor = .clear
        friendsTableView.separatorInset = .zero
        friendsTableView.separatorStyle = .none
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadData.accept(())
        friendsTableView.reloadData()
    }
    // MARK: Binding
    
    private func bindViewModel() {
        let input = FriendViewModel.Input(loadFriends: loadData.asSignal(onErrorJustReturn: ()),
                                          selectFriend: friendsTableView.rx.itemSelected.asSignal(),
                                          searchName: searchBar.searchTextField.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
                                          searchFriend: searchBar.doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.loadData.bind(to: friendsTableView.rx.items(cellIdentifier: "friendsCell", cellType: FriendTableViewCell.self)) { row, model, cell in
            cell.configCell(model)
        }.disposed(by: disposeBag)
        
        output.selectData.drive(onNext: {[unowned self] friend in
            guard let vc = storyboard?.instantiateViewController(identifier: "Profile") as? ProfileViewController else { return }
            vc.friendId = friend
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        output.message.emit(onNext: {[unowned self] text in setAlert(text)}).disposed(by: disposeBag)
    }

    private func setTableView() {
        friendsTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "friendsCell")
    }

    // MARK: Constraint
    
    private func setupConstraint() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.height.equalTo(50)
        }

        friendsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension FriendViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bottomView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: 0))

        bottomView.addBottomBorderWithColor(color: PointColor.primary, width: 1)

        return bottomView
    }
    
}
