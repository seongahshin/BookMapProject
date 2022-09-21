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
    
}
