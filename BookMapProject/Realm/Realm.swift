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

class CalendarData: Object {
    @Persisted var memoregDate: String
    @Persisted var memoTitle: String?
    @Persisted var memoContent: String?
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoregDate: String, memoTitle: String?, memoContent: String?) {
        self.init()
        self.memoregDate = memoregDate
        self.memoTitle = memoTitle
        self.memoContent = memoContent
    }
    
}

class editData: Object {
    @Persisted var editTitle: String?
    @Persisted var editContent: String?
    @Persisted var regDate: Date
    @Persisted var writeDate: Date
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(editTitle: String?, editContent: String?, regDate: Date, writeDate: Date) {
        
        self.init()
        self.editTitle = editTitle
        self.editContent = editContent
        self.regDate = regDate
        self.writeDate = writeDate
    }
    
}
