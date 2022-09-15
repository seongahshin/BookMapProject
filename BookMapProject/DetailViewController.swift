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
//
//    var collectionView: UICollectionView = {
//        let view = UICollectionView()
//        return view
//    }()
    
    override func viewDidLoad() {
        configureUI()
        print("데이터 전달 완료 \(storeInfoList)")
        let labelList: [UILabel] = [storeName, storeAddress, storeTime, storeLink]
        
        for num in 0...labelList.count - 1 {
            labelList[num].text = storeInfoList[num]
        }
        
    }
    
    
    func configureUI() {
        [storeName, storeAddress, storeTime, storeLink].forEach {
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
        
        
        
        
    }
    
    
}
