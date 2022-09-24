//
//  BookCollectionViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/24.
//

import UIKit
import SnapKit

class BookCollectionViewCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return "BookCollectionViewCell"
    }
    
}
