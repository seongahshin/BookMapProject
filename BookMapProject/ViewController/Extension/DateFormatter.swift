//
//  DateFormatter.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/27.
//

import UIKit

extension Date {
    
    
    func resultDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    func resultTime(date: Date) -> String {
        let timeformatter = DateFormatter()
        timeformatter.locale = Locale(identifier: "ko_KR")
        timeformatter.dateFormat = "HH:mm:ss"
        let currentTime = timeformatter.string(from: date)
        return currentTime
    }
    
    func realDate(date: Date) -> String {
        let timeformatter = DateFormatter()
        timeformatter.locale = Locale(identifier: "ko_KR")
        timeformatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss"
        let currentDate = timeformatter.string(from: date)
        return currentDate
    }
    
}
