//
//  BookViewControlelr.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/23.
//

import UIKit

import SnapKit

class BookViewController: UIViewController {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .blue
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
       return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        cell.backgroundColor = .brown
        return cell
    }
    
    
}

extension BookViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width
//        let size = CGSize(width: width, height: 20)
//        return size
        return CGSize(width: 300, height: 400)
    }
    
    
}
