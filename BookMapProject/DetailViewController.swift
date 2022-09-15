//
//  DetailViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/15.
//

import UIKit

import SnapKit

class DetailViewController: UIViewController {
    
    var storeInfoList: [String] = []
    
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
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .orange
        return view
    }()
    
    override func viewDidLoad() {
        configureUI()
        print("데이터 전달 완료 \(storeInfoList)")
        let labelList: [UILabel] = [storeName, storeAddress, storeTime, storeLink]
        
        for num in 0...labelList.count - 1 {
            labelList[num].text = storeInfoList[num]
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
    }
    
    
    func configureUI() {
        [storeName, storeAddress, storeTime, storeLink, collectionView].forEach {
            view.addSubview($0)
        }
        
        storeName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.height.equalTo(50)
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
        
        
    }
    
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .yellow
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
