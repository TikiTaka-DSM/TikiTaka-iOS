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
        cell.chatTime.text = "df"
        cell.lastMessage.text = item.lastMessage
        
        return cell
    }
    
    private let disposeBag = DisposeBag()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chatsTableView)
        view.addSubview(searchBar)
    
        chatsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        setTableView()
        bindViewModel()
    }
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpConstraint()
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input(loadChatList: loadData.asSignal(onErrorJustReturn: ()), selectRoom: chatsTableView.rx.itemSelected.asSignal())
        let output = viewModel.transform(input: input)
        
        output.loadData.drive(chatsTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        output.selectData.drive(onNext: { roomId in
            guard let vc = self.storyboard?.instantiateViewController(identifier: "Chat") as? ChatViewController else { return }
            vc.roomId = roomId
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    func setTableView() {
        chatsTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatsCell")
    }
    
    func setUpConstraint() {

        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
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
        let bottomView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 0))

        bottomView.addTopBorderWithColor(color: PointColor.primary, width: 1)

        return bottomView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorColor = .clear
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
    }
    
}
