//
//  BookViewControlelr.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/23.
//

import UIKit

import SnapKit
import RealmSwift
import Zip

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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationItem.rightBarButtonItem?.tintColor = Color.pointColor
        tasks = localRealm.objects(editData.self).sorted(byKeyPath: "regDate", ascending: false)
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

extension BookViewController {
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        // 1. 도큐먼트 폴더 경로 구성
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory,userDomainMask, true)
        
        if let directoryPath = path.first {
            // 2. 이미지 URL 찾기
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            print("bookVC에서 저장되는 경로 \(imageURL)")
            do {
                let unzipFilePath = try Zip.quickUnzipFile(imageURL)
                print(unzipFilePath)
                // 3. UIImage 로 불러오기
                return UIImage(contentsOfFile: unzipFilePath.path)
            } catch {
                print(error)
                print("오류")
            }
            
        }
        return nil
    }
}

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        let task = tasks[indexPath.row]
        cell.backgroundColor = .white
        cell.imageView.image = loadImageFromDocumentDirectory(imageName: "\(task.objectID).zip")
        cell.titleLabel.text = task.editTitle
        cell.contentLabel.text = task.editContent
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EditViewController()
        let task = tasks[indexPath.row]
        vc.editTitle = task.editTitle!
        vc.editContent = task.editContent!
        vc.fileName = "\(task.objectID)"
        vc.date = task.regDate
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
        return CGSize(width: 350, height: 500)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
//        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
//        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2 - 85
//        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
}
