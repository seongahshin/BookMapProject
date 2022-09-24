//
//  EditViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/24.
//

import UIKit
import Photos
import PhotosUI

import SnapKit
import RealmSwift

class EditViewController: UIViewController {
    
    let localRealm = try! Realm()
    var tasks: Results<editData>!
    
    var editTitle = ""
    var editContent = ""
    var fileName = ""
    var date = ""

    
    
    
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
        configureUI()
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        endButton.setTitle("완료", for: .normal)
        endButton.addTarget(self, action: #selector(endButtonClicked), for: .touchUpInside)
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        deleteButton.setImage(UIImage(systemName: "minus"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        textField.text = editTitle
        textView.text = editContent
        imageView.image = loadImageFromDocumentDirectory(imageName: "\(fileName).png")
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func configureUI() {
        [closeButton,endButton, addButton, imageView, textField, textView].forEach {
            view.addSubview($0)
        }
        
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.trailingMargin.equalToSuperview().inset(10)
            make.height.width.equalTo(20)
        }
        
        endButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
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
    
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        return nil
    }
    
    @objc func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func endButtonClicked() {
        print("endButtonClicked")
        
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(date)'")
        
        if tasks.first != nil {
            // 이미 존재함
            try! localRealm.write {
                tasks.first?.editTitle = textField.text
                tasks.first?.editContent = textView.text
                
                guard let lastImage = tasks.first?.objectID else { return }
                print(lastImage)
                saveImageToDocumentDirectory(imageName: "\(lastImage).png", image: imageView.image!)
            }
            
        } else {
            let task = editData(editTitle: textField.text!, editContent: textView.text!, regDate: "\(Date())", writeDate: Date())
            try! localRealm.write {
                localRealm.add(task)
                saveImageToDocumentDirectory(imageName: "\(task.objectID).png", image: imageView.image!)
            }
        }
        
        print(tasks)
        self.dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        print(1)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func deleteButtonClicked() {
        
    }
    
    
}

extension EditViewController : PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.imageView.image = image as? UIImage
        
                }
            }
        }
        
    }
}



extension EditViewController {
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        // 1. 이미지를 저장할 경로 설정
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3. 이미지 압축(image.pngData())
        guard let data = image.resizeImage(newWidth: 300).pngData() else {
            print("압축이 실패했습니다.")
            return
        }
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기하는 경우
        // 4-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            // 4-2. 이미지 존재한다면 기존경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다")
            }
        }
        
        // 5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
            print("이미지 저장 완료")
        } catch {
            print("이미지를 저장하지 못했습니다")
        }
        
    }
    
    
}
