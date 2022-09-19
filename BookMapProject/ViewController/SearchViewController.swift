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
        
        for num in 0...data.count - 1 {
            nameSearchList.append(data[num].location)
        }
        
        setupSearchController()
        
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
            make.height.equalTo(360)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        view.endEditing(true)
    }
    
    

    
    func searchImage(query: String, completionHandler: @escaping ([String]) -> ()) {
        
        print("그룹 엔터")
        
        print("이미지 다운로드 시작")
        let urlString = "\(EndPoint.imageSearchURL)\(query)&display=6&start=1&sort=sim"
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret]
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
                switch response.result {
                        case .success(let value):
                            let json = JSON(value)
//                            print("JSON: \(json)")
                            let data = json["items"]
                    
                    
                            if data.count >= 6 {
                                for num in 0...5 {
                                    self.imageList.append(data[num]["link"].stringValue)
                                }
                            } else {
                                for num in 0...data.count - 1{
                                    self.imageList.append(data[num]["link"].stringValue)
                                }
                            }
                            print("======== json 결과 =========")
                            
                            print("이미지 다운로드 완료")
                    
//                            print(self.imageList.count)
                            dump(self.imageList)
                    completionHandler(self.imageList)
                            

                        case .failure(let error):
                            print(error)
                        }
                    }
        
        
    
    }
    
    func searchBlog(query: String, completionHandler: @escaping ([Blog]) -> ()) {
        print("리뷰 다운로드 시작")
        blogList.removeAll()
        imageList.removeAll()
        let urlString = "\(EndPoint.blogSearchURL)\(query)&display=6&start=1&sort=sim"
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.blogclientId, "X-Naver-Client-Secret": APIKey.blogclientSecret]
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        
        AF.request(url, method: .get, headers: headers).validate().responseData { [self] response in
                switch response.result {
                        case .success(let value):
                            let json = JSON(value)
//                            print(json)
                            let data = json["items"]
                            if data.count >= 6 {
                                for num in 0...5 {
                                    self.blogList.append(Blog(blogTitle: data[num]["title"].stringValue, blogContent: data[num]["description"].stringValue, blogName: data[num]["bloggername"].stringValue, blogDate: data[num]["postdate"].stringValue, blogLink: data[num]["link"].stringValue))
                                }
                            } else {
                                for num in 0...data.count - 1 {
                                    self.blogList.append(Blog(blogTitle: data[num]["title"].stringValue, blogContent: data[num]["description"].stringValue, blogName: data[num]["bloggername"].stringValue, blogDate: data[num]["postdate"].stringValue, blogLink: data[num]["link"].stringValue))
                                }
                            }
                            
                            print("======== json 결과 =========")
                            
                            print("리뷰 다운로드 완료")
                            completionHandler(self.blogList)
                            dump(self.blogList)
                        
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
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
        return isEditMode ? nameSearchListFilter.count : nameSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.titleLabel.text = isEditMode ? nameSearchListFilter[indexPath.row] : nameSearchList[indexPath.row]
        cell.titleLabel.font = UIFont(name: FontManager.GangWonLight, size: 12)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print(#function)
        
       if !isEditMode {
           
           let vc = DetailViewController()
           infoList = [nameSearchList[indexPath.row], data[indexPath.row].address, data[indexPath.row].time, data[indexPath.row].link]

           vc.storeInfoList = infoList

           DispatchQueue.global().sync {
               searchImage(query: infoList[0]) { value in
                   print("벨류 \(value)")
                   self.imageList = value
                   vc.storImageList = value
                   
               }
           }
           
           DispatchQueue.global().sync {
               searchBlog(query: infoList[0]) { value in
                   self.blogList = value
                   vc.getBlogList = value
                   self.navigationController?.pushViewController(vc, animated: true)
               }
           }
           
            print("데이터 전달")
            
            tableView.deselectRow(at: indexPath, animated: true)
       } else {
           let vc = DetailViewController()
           infoList = [nameSearchListFilter[indexPath.row], data[indexPath.row].address, data[indexPath.row].time, data[indexPath.row].link]

           vc.storeInfoList = infoList

           DispatchQueue.global().sync {
               searchImage(query: infoList[0]) { value in
                   print("벨류 \(value)")
                   self.imageList = value
                   vc.storImageList = value
                   
               }
           }
           
           DispatchQueue.global().sync {
               searchBlog(query: infoList[0]) { value in
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
