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

class MainViewController: UIViewController {

    private let chatsTableView = UITableView().then {
        $0.rowHeight = 70
    }
    
    private let searchBar = SearchBar().then {
        $0.backgroundColor = PointColor.primary
    }

    var sections = [
        Section(header: "First", items: [Friend(id: "asdf", img: nil, name: "gi", statusMessage: "Cjdq")]),
        Section(header: "Second", items: [Friend(id: "asdf", img: nil, name: "gi", statusMessage: "Cjdq")]),
    ]
    
    let dataSource = RxTableViewSectionedReloadDataSource<Section>  { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatsCell", for: indexPath) as! ChatTableViewCell
        cell.separatorInset = UIEdgeInsets.zero

        cell.chatImg.image = UIImage(named: "TikiTaka_logo.png")
        cell.chatName.text = item.name
        cell.chatTime.text = "오전"
        cell.lastMessage.text = "안녕"
        
        return cell
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chatsTableView)
        view.addSubview(searchBar)
    
        chatsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        setTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpConstraint()
    }
    
    func setTableView() {
        
        chatsTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatsCell")
        
        Observable.just(sections)
          .bind(to: chatsTableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
//        sections.bind(to: chatsTableView.rx.items(cellIdentifier: "chatsCell")) { row, model, cell in
//            cell.imageView?.image = UIImage(named: "TikiTaka_logo.png")
//            self.forCornerRadius(cell.imageView!)
//            cell.textLabel?.text = model.name
//        }.disposed(by: disposeBag)
        
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
    }
    
}
