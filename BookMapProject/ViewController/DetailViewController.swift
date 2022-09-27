//
//  DetailViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/15.
//

import UIKit

import SnapKit
import Alamofire
import SwiftyJSON
import Kingfisher
import RealmSwift

class DetailViewController: UIViewController {
    
    let localRealm = try! Realm()
    let data = dummyData().decode()
    var storeInfoList: [String] = []
    var storImageList: [String] = []
    var getBlogList: [Blog] = []
    var BoolResult = false
    var tasks: Results<BookStore>!
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    var contentView : UIView = {
        let view = UIView()
        return view
    }()
    
    var storeName: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonBold, size: 30)
        return view
    }()
    
    var saveButton: UIButton = {
        let view = UIButton()
        view.tintColor = Color.pointColor
        return view
    }()
    
    var storeAddress: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonLight, size: 18)
        return view
    }()
    
    var storeTime: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonLight, size: 18)
        return view
    }()
    
    var storeLink: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonLight, size: 18)
        return view
    }()

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = false
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.isScrollEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        
        
        self.navigationController?.navigationBar.tintColor = Color.pointColor
        configureUI()
        print("데이터 전달 완료 \(storeInfoList)")
        print("데이터 전달 완료 \(storImageList)")
        labelDesign()
        view.backgroundColor = backgroundColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BlogTableViewCell.self, forCellReuseIdentifier: BlogTableViewCell.identifier)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        tasks = localRealm.objects(BookStore.self).sorted(byKeyPath: "name")
        saveButtonDesign()
        
    }
    
    
    func saveButtonDesign() {
        let deleteTasks = localRealm.objects(BookStore.self).filter("name == '\(storeName.text!)'").first?.saved
        
        if deleteTasks == true {
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    func labelDesign() {
        let labelList: [UILabel] = [storeName, storeAddress, storeTime, storeLink]
        
        for num in 0...labelList.count - 1 {
            labelList[num].text = storeInfoList[num]
        }
    }
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [storeName, storeAddress, saveButton, storeTime, storeLink, collectionView, tableView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
        }
        
        storeName.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).inset(10)
            make.width.equalTo(UIScreen.main.bounds.width / 2 - 10)
            make.height.equalTo(40)
        }
        
        
        storeAddress.snp.makeConstraints { make in
            make.top.equalTo(storeName.snp.bottom)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailingMargin.equalTo(-10)
            make.bottom.equalTo(storeAddress.snp.top)
            make.height.width.equalTo(40)
            
        }
        
        storeTime.snp.makeConstraints { make in
            make.top.equalTo(storeAddress.snp.bottom)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(40)
        }
        
        storeLink.snp.makeConstraints { make in
            make.top.equalTo(storeTime.snp.bottom)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(storeLink.snp.bottom).offset(10)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(260)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(650)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        
    }
    
    @objc func saveButtonClicked() {
        
        if !BoolResult {
            // 저장
            for num in 0...data.count - 1 {
                if storeName.text! == data[num].location {
                    let task = BookStore(name: storeName.text!, latitude: data[num].latitude, longitude: data[num].longitude, saved: false)
                    
                    try! localRealm.write {
                        task.saved = true
                        localRealm.add(task)
                    }
                }
            }
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            BoolResult = true
            
        } else {
            // 삭제
            let deleteTasks = localRealm.objects(BookStore.self).filter("name == '\(storeName.text!)'")
            
            try! localRealm.write {
                localRealm.delete(deleteTasks)
            }
            
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            BoolResult = false
        }
        
    }
    
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storImageList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell

        if let imageURL = URL(string: storImageList[indexPath.item]) {
//            cell.imageView.kf.setImage(with: imageURL)
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: imageURL, placeholder: nil, options: [.transition(.fade(1.2)), .forceTransition], completionHandler: nil)
        }
        
        return cell
    }
    
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        let size = CGSize(width: width, height: width)
        return size
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "리뷰"
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getBlogList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlogTableViewCell.identifier, for: indexPath) as! BlogTableViewCell
        
        cell.titleLabel.text = getBlogList[indexPath.row].blogTitle.htmlEscaped
        cell.titleLabel.font = UIFont(name: FontManager.GangWonBold, size: 15)
        
        cell.contentLabel.text = getBlogList[indexPath.row].blogContent.htmlEscaped
        cell.contentLabel.font = UIFont(name: FontManager.GangWonLight, size: 12)
        cell.contentLabel.textColor = .gray
        
        cell.blogerLabel.text = "\(getBlogList[indexPath.row].blogName) | \(getBlogList[indexPath.row].blogDate)"
        cell.blogerLabel.font = UIFont(name: FontManager.GangWonLight, size: 10)
        cell.blogerLabel.textColor = .lightGray
        
        cell.selectionStyle = .none
        
        print("----확인 -----")
        dump(getBlogList)
        
        
                
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebViewController()
        vc.blogURL = getBlogList[indexPath.row].blogLink
        self.present(vc, animated: true)
        
    }
    
}
