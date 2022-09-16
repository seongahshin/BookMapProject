//
//  SearchTableViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/16.
//

import UIKit

import SnapKit

class SearchTableViewCell: UITableViewCell {

    
    static var identifier: String {
        return "SearchTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
