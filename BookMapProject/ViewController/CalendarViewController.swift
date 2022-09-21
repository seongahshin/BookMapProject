//
//  CalendarViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/21.
//

import UIKit

import FSCalendar
import SnapKit
import RealmSwift

class CalendarViewController: UIViewController {
    
    var events: [Date] = []
    let localRealm = try! Realm()
    var tasks: Results<CalendarData>!
    
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
    
    var saveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        configureUI()
        calendarDesign()
        calendar.delegate = self
        memoTitle.delegate = self
        memoContent.delegate = self
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    func configureUI() {
        
        [calendar,tutorialLabel, contentView].forEach {
            view.addSubview($0)
        }
        
        [memoTitle, memoContent, saveButton].forEach {
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
            make.left.right.equalTo(contentView).inset(15)
            make.top.equalTo(memoTitle.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(memoContent.snp.bottom).offset(5)
            make.left.right.equalTo(contentView).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
    }
    
    @objc func saveButtonClicked()  {
        
        if memoTitle.text != nil && memoContent.text != nil {
            
            
            guard let pickedDate = UserDefaults.standard.string(forKey: "SelectedDate") else { return }
            let tasks = localRealm.objects(CalendarData.self).filter("memoregDate == '\(pickedDate)'")
            
            if tasks.first != nil {
                // 이미 날짜가 존재할 때 (수정)
                try! localRealm.write {
                    tasks.first?.memoTitle = memoTitle.text
                    tasks.first?.memoContent = memoContent.text
                }
                
                
            } else {
                // 날짜 존재하지 않을 때 (새로 저장)
                let task = CalendarData(memoregDate: pickedDate, memoTitle: memoTitle.text, memoContent: memoContent.text)
                
                try! localRealm.write {
                    localRealm.add(task)
                }
                
            }
            print(tasks)
            
            
        } else {
            // 칸 채우라고 토스트 알림 띄우기
            
        }
    }
    
    
}

extension CalendarViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
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
        
        UserDefaults.standard.set("\(date)", forKey: "SelectedDate")
        
        tutorialLabel.isHidden = true
        contentView.isHidden = false
        
        guard let pickedDate = UserDefaults.standard.string(forKey: "SelectedDate") else { return }
        let tasks = localRealm.objects(CalendarData.self).filter("memoregDate == '\(pickedDate)'")
        
        if tasks.first != nil {
            memoTitle.text = tasks.first?.memoTitle
            memoContent.text = tasks.first?.memoContent
        } else {
            memoTitle.text = ""
            memoContent.text = ""
        }
        
    }
}

