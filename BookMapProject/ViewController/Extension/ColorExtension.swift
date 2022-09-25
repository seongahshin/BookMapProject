//
//  BackgroundColorExtension.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/20.
//

import UIKit

extension UIViewController {
    
    var backgroundColor: UIColor {
        return .white
    }
    
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

class Color {

    static var pointColor: UIColor {
        return .yellow
    }
    
    static var calendarDateColor: UIColor {
        return UIColor(r: 204, g: 204, b: 051)
    }
    
    static var memoColor: UIColor {
        return UIColor(r: 204, g: 204, b: 102)
    }
    
    static var saveButtonColor: UIColor {
        return UIColor(r: 251, g: 242, b: 207)
    }
    
    static var todaydateColor: UIColor {
        return UIColor(r: 257, g: 217, b: 161)
    }
    
    static var selectdateColor: UIColor {
        return UIColor(r: 207, g: 210, b: 207)
    }
    
    static var eventColor: UIColor {
        return UIColor(r: 250, g: 148, b: 148)
    }
    
    static var cardColor: UIColor {
//        return UIColor(r: 245, g: 237, b: 220)
        return UIColor(r: 240, g: 229, b: 207)
    }
}
