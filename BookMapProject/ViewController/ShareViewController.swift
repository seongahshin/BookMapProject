//
//  ShareViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/10/12.
//

import UIKit

import SnapKit

class ShareViewController: UIViewController {
    
    var sendedTitle = ""
    var sendedText = ""
    var sendedImage: UIImage!
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.instagramColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont(name: FontManager.GangWonBold, size: 15)
        return view
    }()
    
    var contentLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont(name: FontManager.GangWonLight, size: 12)
        view.numberOfLines = 0
        view.sizeToFit()
        return view
    }()
    
    var shareButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Instagram"), for: .normal)
        view.sizeToFit()
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        configureUI()
        titleLabel.text = sendedTitle
        contentLabel.text = sendedText
        imageView.image = sendedImage
        shareButton.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
    }
    
    @objc func shareButtonClicked() {
        if let storiesURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesURL) {
                let renderer = UIGraphicsImageRenderer(size: contentView.bounds.size)
                let rendererImage = renderer.image { _ in
                    contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
                }
                // 지원되는 형식에는 JPG, PNG 가 있다.
                guard let imageData = rendererImage.pngData() else { return }
                let pasteboardItems: [String:Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#FFFFFF",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#FFFFFF"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesURL, options: [:], completionHandler: nil)
            }
        } else {
            print("User doesn't have instagram on their device")
        }
    }
    
    func configureUI() {
        [contentView,shareButton].forEach {
            view.addSubview($0)
        }
        
        [imageView, titleLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(294)
            make.height.equalTo(420)
            make.center.equalToSuperview()
        }
        
        
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(10)
            make.right.equalTo(contentView.snp.right)
            make.height.width.equalTo(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leadingMargin.equalTo(imageView.snp.leadingMargin)
            make.trailingMargin.equalTo(imageView.snp.trailingMargin)
            make.height.equalTo(35)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leadingMargin.equalTo(imageView.snp.leadingMargin)
            make.trailingMargin.equalTo(imageView.snp.trailingMargin)
            make.bottom.equalToSuperview().inset(30)
//
        }
    }
    
    
}
