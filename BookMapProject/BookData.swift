//
//  BookData.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/13.
//

import Foundation


class dummyData {
    
    func decode() {
        let jsonData = """
        [
            {
            "storeName": "스페인책방",
            "address": "서울특별시 중구 퇴계로36길 29 기남빌딩 5층 603호",
            "link": "http://www.spainbookshop.com",
            "mapX": 311413,
            "mapY": 551403
            },
            {
            "storeName": "최인아책방",
            "address": "서울특별시 강남구 선릉로 521",
            "link": "http://instagram.com/inabooks",
            "mapX": 316025,
            "mapY": 545304
            },
            {
            "storeName": "이후북스",
            "address": "서울특별시 마포구 망원로4길 24 2층",
            "link": "http://www.afterbookshop.com",
            "mapX": 303179,
            "mapY": 550947
            },
            {
            "storeName": "스토리지북앤필름",
            "address": "서울특별시 용산구 신흥로 115-1",
            "link": "http://www.storagebookandfilm.com",
            "mapX": 310341,
            "mapY": 549661
            },
            {
            "storeName": "땡스북스",
            "address": "서울특별시 마포구 양화로6길 57-6",
            "link": "http://www.thanksbooks.com/",
            "mapX": 304560,
            "mapY": 550185
            },
            {
            "storeName": "유어마인드",
            "address": "서울특별시 서대문구 연희동 132-32 2층 우측",
            "link": "https://your-mind.com/",
            "mapX": 305703,
            "mapY": 552339
            }
        ]
        """

        struct BookData: Decodable {
            var storeName: String
            var address: String
            var link: String
            var mapX: Int
            var mapY: Int
        }
        
        guard let data = jsonData.data(using: .utf8) else {
            fatalError()
        }
        
        do {
            let value = try JSONDecoder().decode([BookData].self, from: data)
            dump(value)
        } catch {
            print(error)
        }
    }
    
}




