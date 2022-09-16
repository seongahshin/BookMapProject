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
        return view
    }()
    
    var blogerLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    var dateLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    static var identifier: String {
        return "BlogTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel, contentLabel, blogerLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
