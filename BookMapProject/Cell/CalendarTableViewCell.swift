//
//  CalendarTableViewCell.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/27.
//

import UIKit

import SnapKit

class CalendarTableViewCell: UITableViewCell {
    
    var CalendarImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var CalendartitleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonBold, size: 14)
        return view
    }()
    
    var CalendarcontentLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonLight, size: 12)
        return view
    }()
    
    static var identifier: String {
        return "CalendarTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [CalendarImageView, CalendartitleLabel, CalendarcontentLabel].forEach {
            contentView.addSubview($0)
        }
        
        CalendarImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(CalendarImageView.snp.height)
        }
        
        CalendartitleLabel.snp.makeConstraints { make in
            make.left.equalTo(CalendarImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(25)
        }
        
        CalendarcontentLabel.snp.makeConstraints { make in
            make.left.equalTo(CalendarImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(CalendartitleLabel.snp.bottom)
            make.height.equalTo(25)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
