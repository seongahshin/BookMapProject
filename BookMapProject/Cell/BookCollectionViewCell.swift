//
//  BookCollectionViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/24.
//

import UIKit
import SnapKit

class BookCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonBold, size: 15)
        return view
    }()
    
    var contentLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonLight, size: 12)
        view.numberOfLines = 0
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    func configureUI() {
        
        [imageView, titleLabel, contentLabel].forEach {
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leadingMargin.equalTo(imageView.snp.leadingMargin)
            make.trailingMargin.equalTo(imageView.snp.trailingMargin)
            make.height.equalTo(35)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leadingMargin.equalTo(imageView.snp.leadingMargin)
            make.trailingMargin.equalTo(imageView.snp.trailingMargin)
            make.bottom.equalToSuperview().inset(30)
//
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return "BookCollectionViewCell"
    }
    
}
