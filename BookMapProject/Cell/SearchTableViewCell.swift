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
    
    static var identifier: String {
        return "SearchTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
