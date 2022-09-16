//
//  BlogTableViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/16.
//

import UIKit

import SnapKit

class BlogTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    var contentLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }()
    
    var blogerLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    static var identifier: String {
        return "BlogTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel, contentLabel, blogerLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(5)
            make.trailingMargin.equalTo(-5)
            make.top.equalTo(5)
            make.height.equalTo(25)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leadingMargin.equalTo(5)
            make.trailingMargin.equalTo(-5)
            make.height.equalTo(40)
        }
        
        blogerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leadingMargin.equalTo(5)
            make.trailingMargin.equalTo(-5)
            make.height.equalTo(15)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
