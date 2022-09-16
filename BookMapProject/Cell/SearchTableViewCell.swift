//
//  SearchTableViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/16.
//

import UIKit

import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    var addressLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    static var identifier: String {
        return "SearchTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel,addressLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(5)
            make.trailingMargin.equalTo(-5)
            make.top.equalTo(5)
            make.height.equalTo(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(5)
            make.trailingMargin.equalTo(-5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
