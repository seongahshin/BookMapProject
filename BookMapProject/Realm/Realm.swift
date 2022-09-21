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
    @Persisted var memoregDate: String // 필수
    @Persisted var memoTitle: String? // 필수
    @Persisted var memoContent: String? // 옵션
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoregDate: String, memoTitle: String?, memoContent: String?) {
        self.init()
        self.memoregDate = memoregDate
        self.memoTitle = memoTitle
        self.memoContent = memoContent
    }
    
}
