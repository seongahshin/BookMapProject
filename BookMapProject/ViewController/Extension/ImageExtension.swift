//
//  ImageExtension.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/24.
//

import UIKit


extension UIImage {
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newheight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newheight)
        let render = UIGraphicsImageRenderer(size: size)
        let rendrImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        print("화면배율: \(UIScreen.main.scale)") // 배수
        print("origin: \(self), resize: \(rendrImage)")
        return rendrImage
    }
    
    
}
