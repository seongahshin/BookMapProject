//
//  ZipExtension.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/26.
//

import UIKit

extension UIViewController {
    
    //MARK: - ZIP
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        // 1. 이미지를 저장할 경로 설정
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3. 이미지 압축(image.pngData())
        guard let data = image.resizeImage(newWidth: 120).pngData() else {
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
            print("이미지 저장")
        }
        catch {
          print("Something went wrong")
        }
        
    }
    
    //MARK: - UNZIP 하지 않고 파일 그대로 표현
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
}
