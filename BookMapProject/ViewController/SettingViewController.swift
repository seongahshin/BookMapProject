//
//  SettingViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/20.
//

import UIKit

import SnapKit

class SettingViewController: UIViewController {
    
    var tableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        self.navigationItem.title = "설정"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        configureUI()
    }
    
    func configureUI() {
        [tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
