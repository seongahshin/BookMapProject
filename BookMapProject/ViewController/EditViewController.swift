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
import Toast

class EditViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    let localRealm = try! Realm()
    var tasks: Results<editData>!
    let imagePicker = UIImagePickerController()
    
    var editTitle = ""
    var editContent = ""
    var fileName = ""
    var date = ""
    var clickedDate = ""
    var index = 0
    
    var closeButton: UIButton = {
        let view = UIButton()
        view.tintColor = Color.memoColor
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
        view.placeholder = "내용을 입력해주세요:)"
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
        imageView.image = loadImageFromDocumentDirectory(imageName: "\(fileName)")
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.delegate = self // picker delegate
        
        textField.delegate = self
        
        print(index)
        print(editTitle)
        print(editContent)
        print(fileName)
        print(date)
        print(clickedDate)
        guard let click = UserDefaults.standard.string(forKey: "SelectedDate") else { return }
        print(click)
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func configureUI() {
        [closeButton, deleteButton, endButton, imageView, textField, textView].forEach {
            view.addSubview($0)
        }
        
        [addButton].forEach {
            imageView.addSubview($0)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(imageView.snp.width)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
//
//
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.width.equalTo(imageView.snp.width)
            make.height.equalTo(40)
        }
//
        textView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.width.equalTo(textField.snp.width)
            make.height.equalTo(135)
        }
//
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.leadingMargin.equalTo(textView.snp.leadingMargin)
            make.width.height.equalTo(40)
        }

        endButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.trailingMargin.equalTo(textView.snp.trailingMargin)
            make.width.height.equalTo(40)
        }

        
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
        
        let tasks = localRealm.objects(editData.self).filter("regDate == '\(date)'").sorted(byKeyPath: "regTime", ascending: true)
        
        if tasks.count == 0 {
            // 새로 입력
            if textField.text == "" && textView.text == "" && imageView.image == nil {
                self.dismiss(animated: true)
                return
            } else {
                try! localRealm.write {
                    
                    guard let click = UserDefaults.standard.string(forKey: "SelectedDate") else {
                        self.view.makeToast("캘린더탭에서 날짜를 먼저 선택해주세요!", duration: 4)
                        return
                        
                    }
                    
//                    let currentDate = Date().resultDate(date: Date())
                    
                    let currentTime = Date().resultTime(date: Date())
                    
                    let currentRealTime = Date().resultDate(date: Date())
                    
                    let task = editData(editTitle: textField.text!, editContent: textView.text!, regDate: click, regTime: currentTime, realDate: currentRealTime)
                    localRealm.add(task)
                    if imageView.image != nil {
                        saveImageToDocumentDirectory(imageName: "\(task.objectID)", image: imageView.image!)
                    }
                    self.view.makeToast("포토카드가 만들어졌어요 :)", duration: 4)
                    self.dismiss(animated: true)
                }
                
            }
        } else {
            // 기존에 있는 거 수정
            for num in 0...tasks.count - 1 {
                if tasks[num].realDate == clickedDate {
                    try! localRealm.write {
                        tasks[num].editTitle = textField.text
                        tasks[num].editContent = textView.text
                        
                        let lastImage = "\(tasks[num].objectID)"
                        print(lastImage)
                        if imageView.image != nil {
                            saveImageToDocumentDirectory(imageName: "\(lastImage).png", image: imageView.image!)
                        }
                    }
                    self.dismiss(animated: true)
                }
                
            }
            self.view.makeToast("포토카드가 만들어졌어요 :)", duration: 4)
        }
        
        print(tasks)
    }
    
    // 사진 저장
    @objc func addButtonClicked() {
        print(1)
        albumAuth()
        
    }
    
    // 삭제
    @objc func deleteButtonClicked() {
        
        let alert = UIAlertController(title: "알림", message: "정말 기록을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { [self] (action) in
            
            if UserDefaults.standard.bool(forKey: "check") == false {
                
                if let click = UserDefaults.standard.string(forKey: "SelectedDate") {
                    let tasks = self.localRealm.objects(editData.self).filter("regDate == '\(click)'").sorted(byKeyPath: "regTime", ascending: false)
                    print(tasks)
                    if tasks.count > 0 {
                        try! self.localRealm.write {
                            print("locarRealm 시작 \(tasks[self.index])")
                            let lastImage = "\(tasks[self.index].objectID)"
                            self.deleteImageFromDocumentDirectory(imageName: lastImage)
                            self.localRealm.delete(tasks[self.index])
                            print("최종 \(tasks)")
                        }
                        self.dismiss(animated: true)
                        
                    } else {
                        self.dismiss(animated: true)
                    }
                    
                    
                }
                
            } else {
                
            
            let tasks = self.localRealm.objects(editData.self).sorted(by: [SortDescriptor(keyPath: "regDate", ascending: false), SortDescriptor(keyPath: "regTime", ascending: false)])
            print(tasks)
            if tasks.count > 0 {
                try! self.localRealm.write {
                    print("locarRealm 시작 \(tasks[self.index])")
                    let lastImage = "\(tasks[self.index].objectID)"
                    self.deleteImageFromDocumentDirectory(imageName: lastImage)
                    self.localRealm.delete(tasks[self.index])
                    print("최종 \(tasks)")
                }
                self.dismiss(animated: true)
                    
            } else {
                self.dismiss(animated: true)
            }
                    
                    
                
                
                
                
            }
            
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: false, completion: nil)
        
    }
    
    
    
}

extension EditViewController : UIImagePickerControllerDelegate {
    
    func albumAuth() {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .denied:
            print("거부")
            self.showAlertAuth("앨범")
        case .authorized:
            print("허용")
            self.present(self.imagePicker, animated: true)
        case .limited:
            self.present(self.imagePicker, animated: true)
        case .notDetermined, .restricted:
            print("아직 결정하지 않은 상태")
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true)
                    }
                    print("authorized")
                } else {
                    self.dismiss(animated: true)
                }
            }
        default:
            break
        }
    }
    
    func showAlertAuth(
        _ type: String
    ) {
        if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            let alertVC = UIAlertController(
                title: "설정",
                message: "\(appName)이 \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
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
