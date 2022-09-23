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
        let address: String
        let time: String
        let link: String
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
            "mapY": 126.995058,
            "time": "월-금 14:00-20:00 토 13:00-18:00 (휴무:일)"
            },
            {
            "storeName": "최인아책방",
            "address": "서울특별시 강남구 선릉로 521",
            "link": "http://instagram.com/inabooks",
            "mapX": 37.506026,
            "mapY": 127.047922,
            "time": "매일 12:00-19:00"
            },
            {
            "storeName": "이후북스",
            "address": "서울특별시 마포구 망원로4길 24 2층",
            "link": "http://www.afterbookshop.com",
            "mapX": 37.555602,
            "mapY": 126.901935,
            "time": "일-화 13:00-18:00 수-토 11:00-20:00"
            },
            {
            "storeName": "스토리지북앤필름",
            "address": "서울특별시 용산구 신흥로 115-1",
            "link": "http://www.storagebookandfilm.com",
            "mapX": 37.544730,
            "mapY": 126.983092,
            "time": "매일 14:00-19:00"
            },
            {
            "storeName": "땡스북스",
            "address": "서울특별시 마포구 양화로6길 57-6",
            "link": "http://www.thanksbooks.com/",
            "mapX": 37.548881,
            "mapY": 126.917711,
            "time": "매일 12:00-21:00 (휴무:신정,설,추석연휴)"
            },
            {
            "storeName": "유어마인드",
            "address": "서울특별시 서대문구 연희동 132-32 2층 우측",
            "link": "https://your-mind.com/",
            "mapX": 37.568435,
            "mapY": 126.930321,
            "time": "수-월 13:00-20:00 (휴무:화)"
            },
            {
            "storeName": "프루스트의 서재",
            "address": "서울 성동구 무수막길 56 1F",
            "link": "https://blog.naver.com/proust_book",
            "mapX": 37.551243,
            "mapY": 127.021952,
            "time": "화-토 13:00-20:00 (정보없음: 일,월)"
            },
            {
            "storeName": "고요서사",
            "address": "서울 용산구 신흥로15길 18-4",
            "link": "https://blog.naver.com/proust_book",
            "mapX": 37.544354,
            "mapY": 126.985844,
            "time": "목-일 12:00-19:00 (휴무: 월-수)"
            },
            {
            "storeName": "공간과 몰입",
            "address": "서울 종로구 낙산길 19 1층",
            "link": "https://www.instagram.com/gggmolip",
            "mapX": 37.580551,
            "mapY": 127.005597,
            "time": "수,금 19:00-22:00 토,일 13:00-19:00 (휴무: 월,화)"
            },
            {
            "storeName": "이라선",
            "address": "서울 종로구 효자로7길 5 1F",
            "link": "http://www.irasun.co.kr/",
            "mapX": 37.578878,
            "mapY": 126.973456,
            "time": "화-일 12:00-20:00 (휴무: 월)"
            },
            {
            "storeName": "책방오늘",
            "address": "서울 서초구 바우뫼로 154 103호",
            "link": "http://onulbooks.com",
            "mapX": 37.477112,
            "mapY": 127.037312,
            "time": "화-토 13:00-21:00 일 12:00-18:00 (휴무: 월)"
            },
            {
            "storeName": "헬로 인디북스",
            "address": "서울 마포구 동교로46길 33",
            "link": "https://blog.naver.com/indiebooks",
            "mapX": 37.562296,
            "mapY": 126.926571,
            "time": "수-월 15:00-21:00 (휴무: 화)"
            }
        ]
        """

        struct BookData: Decodable {
            var storeName: String
            var address: String
            var link: String
            var mapX: Double
            var mapY: Double
            var time: String
        }
        
        guard let data = jsonData.data(using: .utf8) else {
            fatalError()
        }
        
        
        do {
            let value = try JSONDecoder().decode([BookData].self, from: data)
            
            for num in 0...value.count - 1 {
    
                BookStoreList.append(BookStore(location: value[num].storeName, latitude: value[num].mapX, longitude: value[num].mapY, address: value[num].address, time: value[num].time, link: value[num].link))
            }
            
//            dump(value)
            
        } catch {
            print(error)
        }
        return BookStoreList
    }
    
}





