//
//  MainViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa


class FriendViewController: UIViewController {

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
        
        friendsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        setTableView()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setUpConstraint()
    }

    func bindViewModel() {
        let input = FriendViewModel.Input(loadFriends: loadData.asSignal(onErrorJustReturn: ()),
                                          selectFriend: friendsTableView.rx.itemSelected.asSignal(),
                                          searchName: searchBar.searchTextField.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
                                          searchFriend: searchBar.doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.loadData.bind(to: friendsTableView.rx.items(cellIdentifier: "friendsCell", cellType: FriendTableViewCell.self)) { row, model, cell in
            
            cell.friendImg.kf.setImage(with: URL(string: "https://jobits.s3.ap-northeast-2.amazonaws.com/\(model.img)"))
            cell.friendName.text = model.name
            
        }.disposed(by: disposeBag)

        output.selectData.drive(onNext: { friend in
            guard let vc = self.storyboard?.instantiateViewController(identifier: "Profile") as? ProfileViewController else { return }
            vc.friendId = friend
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    func setTableView() {
        friendsTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "friendsCell")
    }

    func setUpConstraint() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorColor = .clear
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
    }

}
