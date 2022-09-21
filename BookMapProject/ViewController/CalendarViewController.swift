//
//  CalendarViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/21.
//

import UIKit

import FSCalendar
import SnapKit

class CalendarViewController: UIViewController {
    
    var calendar = FSCalendar()
    var events: [Date] = []
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        configureUI()
        calendarDesign()
    }
    
    func configureUI() {
        
        [calendar].forEach {
            view.addSubview($0)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2)
        }
        
    }
    
    func calendarDesign() {
        
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.headerTitleFont = UIFont(name: FontManager.GangWonBold, size: 16)
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = Color.calendarDateColor
        
        calendar.appearance.weekdayFont = UIFont(name: FontManager.GangWonBold, size: 14)
        calendar.appearance.weekdayTextColor = .lightGray
        
        calendar.appearance.titleFont = UIFont(name: FontManager.GangWonBold, size: 14)
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    }
}
