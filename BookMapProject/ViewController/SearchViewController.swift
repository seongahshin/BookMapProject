//
//  SearchViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/16.
//

import UIKit

import SnapKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {
    
    let data = dummyData().decode()
    var searchText = ""
    var nameSearchList: [String] = []
    var nameSearchListFilter: [String] = []
    
    var infoList: [String] = []
    var imageList: [String] = []
    var blogList: [Blog] = []
    
    
    var tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return view
        
    }()
    
    override func viewDidLoad() {
        print(#function)
        print("완료")
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = backgroundColor
        
        for num in 0...data.count - 1 {
            nameSearchList.append(data[num].location)
        }
        
        setupSearchController()
        self.navigationController?.navigationBar.tintColor = Color.pointColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        print(imageList)
        print(blogList)
    }
    
    private func setupSearchController() {

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "찾고 싶은 독립서점명을 입력해주세요"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureUI() {
        print(#function)
        [tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50 * data.count)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        view.endEditing(true)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        nameSearchListFilter = nameSearchList.filter { $0.contains(text) }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    var isEditMode: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEditMode ? nameSearchListFilter.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.titleLabel.text = isEditMode ? nameSearchListFilter[indexPath.row] : nameSearchList[indexPath.row]
        cell.titleLabel.font = UIFont(name: FontManager.GangWonLight, size: 12)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print(#function)
       
       if !NetworkMonitor.shared.isConnected {
           let alert = UIAlertController(title: "실패", message: "데이터 연결이 되어있지 않습니다.", preferredStyle: UIAlertController.Style.alert)
           let badAction = UIAlertAction(title: "설정창으로 이동", style: .default) { (action) in
               if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSetting)
               }
           }
           alert.addAction(badAction)
           present(alert, animated: false, completion: nil)
       } else {
           if isEditMode {
               let vc = DetailViewController()
               
               for num in 0...data.count - 1 {
                   if data[num].location == nameSearchListFilter[indexPath.row] {
                       infoList = [nameSearchListFilter[indexPath.row], data[num].address, data[num].time, data[num].link]
                       dump(infoList)
                   }
               }
               
               vc.storeInfoList = infoList
               
               DispatchQueue.global().sync {
                   
                   APIManager.shared.searchImage(query: infoList[0]) { value in
                       self.imageList = value
                       vc.storImageList = value
                   }
               }
               
               DispatchQueue.global().sync {
                   
                   APIManager.shared.searchBlog(query: infoList[0]) { value in
                       self.blogList = value
                       vc.getBlogList = value
                       self.navigationController?.pushViewController(vc, animated: true)
                   }
               }
               
                print("데이터 전달")
                
                tableView.deselectRow(at: indexPath, animated: true)

           }
       }
        
         
       
       
        
    }
}

