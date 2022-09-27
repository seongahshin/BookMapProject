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
    var tasks: Results<editData>!
    
    let placeholderText = "독립서점을 방문한 오늘의 이야기를 기록해볼까요?"
    
    var calendar = FSCalendar()
    
    var tutorialLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "날짜를 클릭해서 독립서점 방문기록을 남겨보세요 :)"
        view.font = UIFont(name: FontManager.GangWonLight, size: 13)
        view.textColor = .lightGray
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .brown
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        configureUI()
        calendarDesign()
        calendar.delegate = self
        calendar.dataSource = self
        
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
        tableView.reloadData()
    }
    
    func configureUI() {
        
        [calendar,tutorialLabel, tableView].forEach {
            view.addSubview($0)
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

        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
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
        
        calendar.appearance.todayColor = Color.todaydateColor
        calendar.appearance.selectionColor = Color.selectdateColor
        calendar.appearance.eventDefaultColor = Color.eventColor
        calendar.appearance.eventSelectionColor = Color.eventColor
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let currentDate = Date().resultDate(date: date)
        print(currentDate)
        UserDefaults.standard.set(currentDate, forKey: "SelectedDate")
        tutorialLabel.isHidden = true
        tableView.reloadData()
        
        
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let currentDate = Date().resultDate(date: date)
        
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(currentDate)'")
        
        if tasks.count > 0 {
            return tasks.count
        } else {
            return 0
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let pickedDate = UserDefaults.standard.string(forKey: "SelectedDate") else { return 0 }
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(pickedDate)'")
        print(tasks)
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
        guard let pickedDate = UserDefaults.standard.string(forKey: "SelectedDate") else { return cell }
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(pickedDate)'").sorted(byKeyPath: "regTime", ascending: true)
        cell.backgroundColor = .gray
        cell.CalendarImageView.image = loadImageFromDocumentDirectory(imageName: "\(tasks[indexPath.row].objectID)")
        cell.CalendartitleLabel.text = tasks[indexPath.row].editTitle
        cell.CalendarcontentLabel.text = tasks[indexPath.row].editContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditViewController()
        guard let pickedDate = UserDefaults.standard.string(forKey: "SelectedDate") else { return }
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(pickedDate)'").sorted(byKeyPath: "regTime", ascending: true)
        let task = tasks[indexPath.row]
        vc.editTitle = task.editTitle!
        vc.editContent = task.editContent!
        vc.fileName = "\(task.objectID)"
        vc.date = task.regDate
        vc.clickedDate = task.realDate
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

