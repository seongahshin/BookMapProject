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
    
    var events: [Date] = []
    
    var calendar = FSCalendar()
    
    var tutorialLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "날짜를 클릭해서 독립서점 방문기록을 남겨보세요 :)"
        view.font = UIFont(name: FontManager.GangWonLight, size: 13)
        view.textColor = .lightGray
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .brown
        return view
    }()
    
    var memoTitle: UITextField = {
        let view = UITextField()
        view.backgroundColor = .darkGray
        return view
    }()
    
    var memoContent: UITextView = {
        let view = UITextView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        configureUI()
        calendarDesign()
        calendar.delegate = self
    }
    
    func configureUI() {
        
        [calendar,tutorialLabel, contentView].forEach {
            view.addSubview($0)
        }
        
        [memoTitle, memoContent].forEach {
            contentView.addSubview($0)
        }
        
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2 - 20)
        }
        
        tutorialLabel.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        memoTitle.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView).inset(15)
            make.height.equalTo(40)
        }
        
        memoContent.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView).inset(15)
            make.top.equalTo(memoTitle.snp.bottom).offset(15)
        }
        
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        tutorialLabel.isHidden = true
        contentView.isHidden = false
    }
}

