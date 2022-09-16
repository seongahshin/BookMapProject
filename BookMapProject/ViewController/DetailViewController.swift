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

class DetailViewController: UIViewController {
    
    var storeInfoList: [String] = []
    var storImageList: [String] = []
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .orange
        return view
    }()
    
    var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    var storeName: UILabel = {
        let view = UILabel()
        view.backgroundColor = .brown
        return view
    }()
    
    var storeAddress: UILabel = {
        let view = UILabel()
        view.backgroundColor = .brown
        return view
    }()
    
    var storeTime: UILabel = {
        let view = UILabel()
        view.backgroundColor = .brown
        return view
    }()
    
    var storeLink: UILabel = {
        let view = UILabel()
        view.backgroundColor = .brown
        return view
    }()

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = false
        view.backgroundColor = .orange
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .brown
        return view
    }()
    
//    var lastLabel: UILabel = {
//        let view = UILabel()
//        view.numberOfLines = 0
//        view.text = "sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds"
//        return view
//    }()
    
    override func viewDidLoad() {
        configureUI()
        print("데이터 전달 완료 \(storeInfoList)")
        print("데이터 전달 완료 \(storImageList)")
        let labelList: [UILabel] = [storeName, storeAddress, storeTime, storeLink]
        
        for num in 0...labelList.count - 1 {
            labelList[num].text = storeInfoList[num]
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BlogTableViewCell.self, forCellReuseIdentifier: BlogTableViewCell.identifier)
        
        
    }
    
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [storeName, storeAddress, storeTime, storeLink, collectionView, tableView].forEach {
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
            make.left.right.equalTo(contentView).inset(20)
            make.height.equalTo(40)
        }
        
        
        storeAddress.snp.makeConstraints { make in
            make.top.equalTo(storeName.snp.bottom).offset(15)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(40)
        }
        
        storeTime.snp.makeConstraints { make in
            make.top.equalTo(storeAddress.snp.bottom).offset(15)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(40)
        }
        
        storeLink.snp.makeConstraints { make in
            make.top.equalTo(storeTime.snp.bottom).offset(15)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(storeLink.snp.bottom).offset(15)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(245)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(10)
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.height.equalTo(400)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
//        lastLabel.snp.makeConstraints { make in
//            make.left.right.equalTo(contentView).inset(20) // left/right padding 20pt
//            make.top.equalTo(collectionView.snp.bottom).offset(20) // below label1 with margin 20pt
//            make.bottom.equalTo(contentView).offset(-20) // attached to the bottom of the contentview with padding 20pt
//        }
        
        
    }
    
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell

        if let imageURL = URL(string: storImageList[indexPath.item]) {
            cell.imageView.kf.setImage(with: imageURL)
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
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlogTableViewCell.identifier, for: indexPath) as! BlogTableViewCell
        cell.backgroundColor = .purple
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
