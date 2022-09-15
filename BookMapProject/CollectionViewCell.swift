//
//  CollectionViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/15.
//

import UIKit

import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return "CollectionViewCell"
    }
    
    func configureUI() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}
