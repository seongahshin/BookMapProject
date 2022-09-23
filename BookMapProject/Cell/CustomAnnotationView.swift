//
//  CustomAnnotationView.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/22.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "Custom"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    let sesac_image: Int?
    let coordinate: CLLocationCoordinate2D
    
    init(
        sesac_image: Int?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.sesac_image = sesac_image
        self.coordinate = coordinate
        
        super.init()
    }
    
}
