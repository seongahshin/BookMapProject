//
//  Realm.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/19.
//

import Foundation
import RealmSwift

class BookStore: Object {
    @Persisted var name: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var saved = false
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(name: String, latitude: Double, longitude: Double, saved: Bool) {
        self.init()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

class editData: Object {
    @Persisted var editTitle: String?
    @Persisted var editContent: String?
    @Persisted var regDate: String
    @Persisted var regTime: String
    @Persisted var realDate: String
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(editTitle: String?, editContent: String?, regDate: String, regTime: String, realDate: String) {
        
        self.init()
        self.editTitle = editTitle
        self.editContent = editContent
        self.regDate = regDate
        self.regTime = regTime
        self.realDate = realDate
    }
    
}
