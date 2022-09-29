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
            "link": "https://blog.naver.com/goyo_bookshop",
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
            },
            {
            "storeName": "관객의 취향",
            "address": "서울 관악구 관악로 204 3층 301호",
            "link": "http://smartstore.naver.com/yourtastebook",
            "mapX": 37.483833,
            "mapY": 126.946431,
            "time": "월-금 15:00-21:00 토-일 13:00-19:00 (휴무: 설날, 추석)"
            },
            {
            "storeName": "살롱드북",
            "address": "서울 관악구 남부순환로231길 11 태주빌라 1층",
            "link": "https://blog.naver.com/salon_book",
            "mapX": 37.480378,
            "mapY": 126.956973,
            "time": "월-토 14:00-22:00 (휴무: 일)"
            },
            {
            "storeName": "생각의 주인",
            "address": "서울 관악구 솔밭로7길 17",
            "link": "https://www.instagram.com/master_of_thought20/",
            "mapX": 37.480223,
            "mapY": 126.963402,
            "time": "매일 09:00-21:00 (휴무: 매달 1,3번째 화요일)"
            },
            {
            "storeName": "다정한 책방",
            "address": "서울 동작구 동작대로9가길 32 1층 다정한 책방",
            "link": "https://blog.naver.com/freereader1",
            "mapX": 37.479673,
            "mapY": 126.977918,
            "time": "수-일 13:00-21:00 (휴무: 월,화)"
            },
            {
            "storeName": "픽셀 퍼 인치",
            "address": "서울 용산구 한강대로54길 7 301호",
            "link": "https://www.instagram.com/pixel.per.inch",
            "mapX": 37.532840,
            "mapY": 126.972056,
            "time": "화-금 13:00-19:30 토-일 13:20:00 (휴무: 월)"
            },
            {
            "storeName": "믿음문고",
            "address": "서울 서초구 양재천로 95-4 1F",
            "link": "http://www.instagram.com/ffl.books",
            "mapX": 37.476168,
            "mapY": 127.039590,
            "time": "화-토 11:00-19:00 (휴무: 일,월)"
            },
            {
            "storeName": "대륙서점",
            "address": "서울 동작구 성대로 40 1층 대륙서점",
            "link": "https://www.instagram.com/daerukbooks/?igshid=l12z4ktyz22s",
            "mapX": 37.498915,
            "mapY": 126.933293,
            "time": "화-토 10:00-20:00 (휴무: 일)"
            },
            {
            "storeName": "어나더더블유",
            "address": "서울 동작구 사당로30길 42",
            "link": "http://instagram.com/another_writing",
            "mapX": 37.483819,
            "mapY": 126.980752,
            "time": "화-목 11:30-19:00, 금 11:30-17:00 (휴무: 토,일)"
            },
            {
            "storeName": "지금의 세상",
            "address": "서울 동작구 동작대로3길 41 1층",
            "link": "http://www.instagram.com/the_present_world",
            "mapX": 37.478640,
            "mapY": 126.979178,
            "time": "화-일 15:00-21:00 (휴무: 일,월)"
            },
            {
            "storeName": "엠프티폴더스",
            "address": "서울 관악구 행운1길 70 1호",
            "link": "http://emptyfolders.kr",
            "mapX": 37.481750,
            "mapY": 126.956542,
            "time": "화-목 14:30-21:00 금-토 13:30-20:00 (휴무: 일,월)"
            },
            {
            "storeName": "쎄임더스트",
            "address": "서울 성동구 성수일로 44-1 2층",
            "link": "http://www.samedust.org",
            "mapX": 37.544144,
            "mapY": 127.053564,
            "time": "화-일 12:00-20:00 (휴무: 월)"
            },
            {
            "storeName": "아니마 아니무스",
            "address": "서울 광진구 아차산로39길 8 1층",
            "link": "http://instagram.com/_anima.animus",
            "mapX": 37.538661,
            "mapY": 127.077225,
            "time": "월-금 09:30-20:00 토 10:00-20:00 (휴무: 일)"
            },
            {
            "storeName": "책방 책읽는 정원",
            "address": "서울 서초구 논현로7길 24",
            "link": "https://www.instagram.com/bookshop_garden/",
            "mapX": 37.472752,
            "mapY": 127.047894,
            "time": "금,주말 12:00-18:00 수,목 12:00-20:00"
            },
            {
            "storeName": "하우스북스 채널씨",
            "address": "서울 송파구 백제고분로9길 5",
            "link": "https://blog.naver.com/hows_seoul",
            "mapX": 37.509387,
            "mapY": 127.079669,
            "time": "매일 11:00 - 07:00"
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





