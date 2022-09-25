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
import Mantis

class EditViewController: UIViewController, UINavigationControllerDelegate {
    
    let localRealm = try! Realm()
    var tasks: Results<editData>!
    let imagePicker = UIImagePickerController()
    
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
        view.setImage(UIImage(systemName: "checkmark"), for: .normal)
        view.tintColor = Color.eventColor
        return view
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 0.8
        view.layer.borderColor = Color.selectdateColor.cgColor
        return view
    }()
    
    var addButton: UIImageView = {
        let view = UIImageView()
        view.tintColor = Color.selectdateColor
        return view
    }()
    
    var deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "trash"), for: .normal)
        view.tintColor = Color.memoColor
        return view
    }()
    
    var textField: UITextField = {
        let view = UITextField().textFieldDesign()
        view.backgroundColor = Color.saveButtonColor
        return view
    }()
    
    var textView: UITextView = {
        let view = UITextView().textViewDesign()
        view.backgroundColor = Color.saveButtonColor
        return view
    }()
    
    override func viewDidLoad() {
        
        
        view.backgroundColor = .white
        configureUI()
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        endButton.addTarget(self, action: #selector(endButtonClicked), for: .touchUpInside)
        
        addButton.image = UIImage(systemName: "plus")
        
        self.addButton.isUserInteractionEnabled = true
        self.imageView.isUserInteractionEnabled = true
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonClicked)))
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonClicked)))
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        textField.text = editTitle
        textView.text = editContent
        imageView.image = loadImageFromDocumentDirectory(imageName: "\(fileName).png")
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.delegate = self // picker delegate
    }
    
    func configureUI() {
        [closeButton, deleteButton, endButton, imageView, textField, textView].forEach {
            view.addSubview($0)
        }
        
        [addButton].forEach {
            imageView.addSubview($0)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.width.equalTo(imageView.snp.width)
            make.height.equalTo(40)
        }
        
        textView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.width.equalTo(textField.snp.width)
            make.height.equalTo(250)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.leadingMargin.equalTo(textView.snp.leadingMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.width.equalTo(deleteButton.snp.height)
        }
        
        endButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.trailingMargin.equalTo(textView.snp.trailingMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.width.equalTo(endButton.snp.height)
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
    
    func deleteImageFromDocumentDirectory(imageName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        print("이미지 삭제")
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다")
            }
        }
    }
    
    // 화면 닫기
    @objc func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    
    // 저장 완료
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
            if textField.text == "" && textView.text == "" && imageView.image == nil {
                self.dismiss(animated: true)
                return
            } else {
                try! localRealm.write {
                    
                    print("dmdkfjsdljfklsjklsfjklsfdj")
                    let task = editData(editTitle: textField.text!, editContent: textView.text!, regDate: "\(Date())", writeDate: Date())
                    localRealm.add(task)
                    if imageView.image != nil {
                        saveImageToDocumentDirectory(imageName: "\(task.objectID).png", image: imageView.image!)
                    }
                    self.dismiss(animated: true)
            }
                
            }
        }
        
        print(tasks)
    }
    
    // 사진 저장
    @objc func addButtonClicked() {
        print(1)
        self.present(self.imagePicker, animated: true)
        
    }
    
    // 삭제
    @objc func deleteButtonClicked() {
        
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(date)'")
        
        if tasks.first != nil {
            // 이미 존재함
            
            guard let lastImage = tasks.first?.objectID else { return }
            print(lastImage)
            deleteImageFromDocumentDirectory(imageName: "\(lastImage).png")
            
            try! localRealm.write {
                localRealm.delete(tasks)
            }
        
            
        }
        
        self.dismiss(animated: true)
        
    }
    
    
}

extension EditViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            //            imgView.image = image // <- 삭제하고 cropViewControllerDidCrop에서 실행
            
            dismiss(animated: true) {
                self.openCropVC(image: image)
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: CropViewControllerDelegate {
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        imageView.image = cropped
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
            
    private func openCropVC(image: UIImage) {
            
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1.0)
        self.present(cropViewController, animated: true)
    }
}



extension EditViewController {
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        // 1. 이미지를 저장할 경로 설정
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3. 이미지 압축(image.pngData())
        guard let data = image.resizeImage(newWidth: 320).pngData() else {
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
