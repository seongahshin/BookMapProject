//
//  BookViewControlelr.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/23.
//

import UIKit

import SnapKit
import RealmSwift

class BookViewController: UIViewController {
    
    let localRealm = try! Realm()
    var tasks: Results<editData>!
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 50, left: 32, bottom: 50, right: 32)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Color.cardColor
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        configureUI()
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        self.navigationItem.rightBarButtonItem?.tintColor = Color.memoColor
        tasks = localRealm.objects(editData.self).sorted(byKeyPath: "realDate", ascending: false)
        print(tasks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc func plusButtonClicked() {
        let vc = EditViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func configureUI() {
        [collectionView].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
}

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
//        let tasks = localRealm.objects(editData.self).sorted(byKeyPath: "regDate", ascending: false).sorted(byKeyPath: "regTime", ascending: true)
        
        let tasks = localRealm.objects(editData.self).sorted(by: [SortDescriptor(keyPath: "regDate", ascending: false), SortDescriptor(keyPath: "regTime", ascending: false)])
//        let tasks = localRealm.objects(editData.self).sorted(byKeyPath: "regDate", ascending: true).sorted(byKeyPath: "regTime", ascending: true)
        let task = tasks[indexPath.row]
        cell.backgroundColor = .white
        cell.imageView.image = loadImageFromDocumentDirectory(imageName: "\(task.objectID)")
        cell.titleLabel.text = task.editTitle
        cell.contentLabel.text = task.editContent
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EditViewController()
        let tasks = localRealm.objects(editData.self).sorted(by: [SortDescriptor(keyPath: "regDate", ascending: false), SortDescriptor(keyPath: "regTime", ascending: false)])
        let task = tasks[indexPath.row]
        vc.index = indexPath.item
        vc.editTitle = task.editTitle!
        vc.editContent = task.editContent!
        vc.fileName = "\(task.objectID)"
        vc.date = task.regDate
        UserDefaults.standard.set(task.regDate, forKey: "SelectedDate")
        vc.clickedDate = task.realDate
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
}

extension BookViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 75
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width
//        let size = CGSize(width: width, height: 20)
//        return size
//        return CGSize(width: 266, height: 380)
//        return CGSize(width: 280, height: 400)
        return CGSize(width: 294, height: 420)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { 
        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    }
    
}
