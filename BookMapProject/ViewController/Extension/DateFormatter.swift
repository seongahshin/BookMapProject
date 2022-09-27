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
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    func resultTime(date: Date) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let currentTime = timeformatter.string(from: date)
        return currentTime
    }
    
}
