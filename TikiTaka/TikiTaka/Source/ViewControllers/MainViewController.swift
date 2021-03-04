//
//  MainViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias ChatListSection = SectionModel<String, ChatList>
typealias ChatListDataSource = RxTableViewSectionedReloadDataSource<ChatListSection>

class MainViewController: UIViewController {

    // MARK: UI
    
    private let chatsTableView = UITableView().then {
        $0.rowHeight = 70
    }
    
    private let searchBar = SearchBar().then {
        $0.backgroundColor = PointColor.primary
    }

    private let viewModel = MainViewModel()
    
    private let dataSource = ChatListDataSource { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatsCell", for: indexPath) as! ChatTableViewCell
        cell.separatorInset = UIEdgeInsets.zero

        cell.chatImg.kf.setImage(with: URL(string: "https://jobits.s3.ap-northeast-2.amazonaws.com/\(item.user.img)"), completionHandler:  { result in
            cell.setNeedsLayout()
        })
        cell.chatName.text = item.user.name
        cell.chatTime.text = item.lastMessage
        cell.lastMessage.text = item.lastMessage
        
        return cell
    }
    
    private let disposeBag = DisposeBag()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chatsTableView)
        view.addSubview(searchBar)
        
        chatsTableView.delegate = self
        
        setTableView()
        bindViewModel()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        chatsTableView.separatorColor = .clear
        chatsTableView.separatorInset = .zero
        chatsTableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpConstraint()
    }
    
    // MARK: Binding
    
    private func bindViewModel() {
        let input = MainViewModel.Input(loadChatList: loadData.asSignal(onErrorJustReturn: ()),
                                        selectRoom: chatsTableView.rx.itemSelected.asSignal())
        let output = viewModel.transform(input: input)
        
        output.loadData.drive(chatsTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        output.selectData.drive(onNext: { [unowned self] roomId in
            guard let vc = storyboard?.instantiateViewController(identifier: "Chat") as? ChatViewController else { return }
            vc.roomId = roomId
            print("select \(roomId)")
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setTableView() {
        chatsTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatsCell")
    }
    
    // MARK: Constraint
    
    private func setUpConstraint() {

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        
        chatsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bottomView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: 0))

        bottomView.addTopBorderWithColor(color: PointColor.primary, width: 1)

        return bottomView
    }
    
}
