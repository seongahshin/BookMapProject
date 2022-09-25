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
        view.backgroundColor = .yellow
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    func configureUI() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(15)
            make.height.equalTo(self.snp.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return "BookCollectionViewCell"
    }
    
}
