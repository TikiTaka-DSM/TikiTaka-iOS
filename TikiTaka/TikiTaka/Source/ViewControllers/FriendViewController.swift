//
//  MainViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import UIKit

class FriendViewController: UIViewController {

    let friendsTableView = UITableView().then {
        $0.separatorColor = PointColor.primary
        $0.rowHeight = 73
        $0.backgroundColor = PointColor.primary
    }
    
    let searchBar = SearchBar().then {
        $0.backgroundColor = PointColor.primary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(friendsTableView)
        view.addSubview(searchBar)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpConstraint()
    }
    
    func setTableView() {
        friendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendsCell")
        
    }
    
    func setUpConstraint() {

        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.height.equalTo(50)
        }
        
        friendsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
        }
        
    }
}
