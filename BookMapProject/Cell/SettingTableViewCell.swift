//
//  SettingTableViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/20.
//

import UIKit

import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    static var identifier: String {
        return "SettingTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
