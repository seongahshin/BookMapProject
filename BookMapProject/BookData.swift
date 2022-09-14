//
//  BookData.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/13.
//

import Foundation


class dummyData {
    
    struct BookStore: Codable {
//                let type: String
        let location: String
        let latitude: Double
        let longitude: Double
    }
    
    
    func decode() -> [BookStore] {
        var BookStoreList: [BookStore] = []
        let jsonData = """
        [
            {
            "storeName": "스페인책방",
            "address": "서울특별시 중구 퇴계로36길 29 기남빌딩 5층 603호",
            "link": "http://www.spainbookshop.com",
            "mapX": 37.560543,
            "mapY": 126.995058
            },
            {
            "storeName": "최인아책방",
            "address": "서울특별시 강남구 선릉로 521",
            "link": "http://instagram.com/inabooks",
            "mapX": 37.506026,
            "mapY": 127.047922
            },
            {
            "storeName": "이후북스",
            "address": "서울특별시 마포구 망원로4길 24 2층",
            "link": "http://www.afterbookshop.com",
            "mapX": 37.555602,
            "mapY": 126.901935
            },
            {
            "storeName": "스토리지북앤필름",
            "address": "서울특별시 용산구 신흥로 115-1",
            "link": "http://www.storagebookandfilm.com",
            "mapX": 37.544730,
            "mapY": 126.983092
            },
            {
            "storeName": "땡스북스",
            "address": "서울특별시 마포구 양화로6길 57-6",
            "link": "http://www.thanksbooks.com/",
            "mapX": 37.548881,
            "mapY": 126.917711
            },
            {
            "storeName": "유어마인드",
            "address": "서울특별시 서대문구 연희동 132-32 2층 우측",
            "link": "https://your-mind.com/",
            "mapX": 37.568435,
            "mapY": 126.930321
            }
        ]
        """

        struct BookData: Decodable {
            var storeName: String
            var address: String
            var link: String
            var mapX: Double
            var mapY: Double
        }
        
        guard let data = jsonData.data(using: .utf8) else {
            fatalError()
        }
        
        
        do {
            let value = try JSONDecoder().decode([BookData].self, from: data)
            
            for num in 0...value.count - 1 {
    
            BookStoreList.append(BookStore(location: value[num].storeName, latitude: value[num].mapX, longitude: value[num].mapY))
            }
            
            dump(value)
            
        } catch {
            print(error)
        }
        return BookStoreList
    }
    
}





