//
//  EditViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/24.
//

import UIKit

import SnapKit

class EditViewController: UIViewController {
    
    var closeButton: UIButton = {
        let view = UIButton()
        view.tintColor = Color.pointColor
        return view
    }()
    
    var endButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .brown
        return view
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .brown
        return view
    }()
    
    var addButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        return view
    }()
    
    var deleteButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        return view
    }()
    
    var textField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .darkGray
        return view
    }()
    
    var textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        endButton.setTitle("완료", for: .normal)
        endButton.addTarget(self, action: #selector(endButtonClicked), for: .touchUpInside)
        configureUI()
    }
    
    func configureUI() {
        [closeButton,endButton, imageView, textField, textView].forEach {
            view.addSubview($0)
        }
        
        [addButton, deleteButton].forEach {
            imageView.addSubview($0)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(20)
        }
        
        endButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.trailingMargin.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(80)
            make.height.equalTo(350)
            make.width.equalTo(300)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leadingMargin.equalTo(30)
            make.height.width.equalTo(100)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leadingMargin.equalTo(addButton.snp.trailingMargin).offset(50)
            make.height.width.equalTo(100)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalTo(imageView.snp.width)
            make.height.equalTo(40)
        }
        
        textView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.equalTo(textField.snp.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    @objc func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func endButtonClicked() {
        self.dismiss(animated: true)
    }
    
    
}
