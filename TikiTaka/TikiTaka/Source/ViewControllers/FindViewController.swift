//
//  FindViewController.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/09.
//

import UIKit
import RxSwift
import RxCocoa

class FindViewController: UIViewController {

    private let searchBar = SearchBar().then {
        $0.backgroundColor = PointColor.primary
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = PointColor.primary
        $0.text = "검색을 통해 친구를 찾아보세요!"
    }
    
    private let dispsoeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchBar)
        view.addSubview(errorLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpConstraint()
    }
    
    func setUpConstraint() {

        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
