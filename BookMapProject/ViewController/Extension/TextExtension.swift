//
//  TextExtension.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/25.
//

import UIKit

extension UITextField {
    
    func textFieldDesign() -> UITextField {
        let view = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.layer.backgroundColor = (Color.memoColor.cgColor).copy(alpha: 0.5)
        view.font = UIFont(name: FontManager.GangWonLight, size: 15)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }
    
}

extension UITextView {
    func textViewDesign() -> UITextView {
        let view = UITextView()
        view.layer.backgroundColor = (Color.memoColor.cgColor).copy(alpha: 0.5)
        view.font = UIFont(name: FontManager.GangWonLight, size: 14)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        return view
    }
}
