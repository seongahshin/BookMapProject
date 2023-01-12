# 북트립

| 앱 이름 | 북트립 |
| --- | --- |
| 진행 기간 | 2022년 9월 13일 ~ 2022년 9월 29일 (16일) |
| 앱 소개 | 지도를 통해 근처 가까운 독립서점에 대한 정보를 찾고 독립서점에 대한 방문기록을 날짜별로 저장하는 기능을 통해 독립서점을 좀 더 즐겁게 이용할 수 있도록 도와주는 앱 |
|  앱 기능 | 독립서점 위치 정보 제공 기능, 독립서점 상세 정보 제공 기능, 날짜별 독립서점 방문기록 저장 기능, 독립서점 방문기록 기반 포토카드 생성 기능, 독립서점 방문 사진 인스타그램 공유 기능 |
| 디자인 패턴 | MVC |
| 화면 | UIKit, SnapKit, AutoLayout |
| 데이터베이스 | Realm |
| 서버 | Firebase Analytics |
| 라이브러리 | Alamofire, FSCalendar, IQKeyboardManager, KingFisher, Mantis, SwiftyJSON, Toast, Mapkit |  

### *⚒ 앱 스크린샷*

<img width="1078" alt="스크린샷 2022-12-16 오후 7 04 29" src="https://user-images.githubusercontent.com/90595710/211734105-d12c1657-cccb-432d-b357-34d1be108607.png"><br>


### *🎯 기술 명세*

- `SnapKit` 을 활용하여 코드 베이스로 `Auto Layout` 구현
- `Decodable` 을 이용해 독립서점 `JSON` 데이터 설계 및 처리
- `MapKit` 과 `CLLocation` 을 이용해 현재 위치와 독립서점 Annotation 표시 기능 구현
- 사용자가 저장한 독립서점은 `Realm`의 `Filter` 기능을 활용해 저장된 독립서점만 Annotation 표시
- Naver Search API를 `Singleton Pattern` 으로 관리하여 메모리 낭비를 방지
- `FSCalendar` 를 이용해 캘린더 기능을 구현하고 `Realm` 을 활용해 `CRUD/정렬 기능` 구현
- otf 폰트를 `Fonts provided by application` 에 추가하여 앱 기본 폰트 변경
- `Queried URL Schemes` 에 instagram-stories 를 추가하여 UIView 를 png 데이터로 변경하여 인스타그램 스토리에 독립서점 방문 사진을 공유할 수 있는 기능 구현
- `UIGraphicsImageRenderer` 를 통해 `FileManager` 의 `Document` 에 저장되는 이미지 용량 처리
- `Firebase Cloud Messaging` 을 전송하여 앱의 유입률을 높임
- `Firebase Analytics` 을 통해 사용자가 오래 머무는 Event 분석


### *👩🏻‍💻 트러블 슈팅*  <br>
#### *1. 외부 API를 사용하지 않고 독립서점 정보를 담은 데이터를 직접 설계해야 하는 이슈* <br>


 🧷  문제


JSON 데이터에 담아야 하는 독립서점 정보가 담긴 외부 API 가 존재하지 않아 직접 데이터를 설계할 필요성을 느꼈다. 


🎨 해결 


JSON 형태의 데이터를 BookData 구조체에 파싱을 하는 Decoding을 실행한 후, return 된 value 값을 BookStoreList에 추가하여 각 독립서점의 정보에 접근할 수 있도록 하였다.  


```swift
class Data {
    
    struct BookStore: Codable {
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
            }
            // 생략
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
            
            
        } catch {
            print(error)
        }
        return BookStoreList
    }
    
}
```


#### *2. 카메라 및 앨범의 사진을 DB에 저장할 때의 파일 크기 이슈*


🧷  문제


DB에 이미지를 직접 저장하게 되면 파일 용량이 점점 늘어나 앱이 무거워진다.

🎨 해결


DB에는 이미지 파일명만 String 타입으로 저장하고 실제 이미지는 FileManager의 DocumentDirectory에 저장하여 이슈를 해결하였다. 


```swift
func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
       
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        guard let data = image.resizeImage(newWidth: 140).pngData() else {
            return
        }
     
        if FileManager.default.fileExists(atPath: imageURL.path) {
          
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다")
            }
        }
        
        do {
            try data.write(to: imageURL)
            print("이미지 저장")
        }
        catch {
          print("Something went wrong")
        }
        
    }
```


#### *3. 실시간 위치를 클릭했을 때 앱이 꺼지는 이슈*


🧷  문제


실시간 위치를 나타내는 Annotation을 클릭했을 때 앱이 꺼지는 현상이 나타났다. 


🎨 해결


as? 는 "런타임 시점"에 다운 캐스팅을 하고 실패할 경우 nil을 return 하지만, as!는 "런타임 시점"에 다운 캐스팅을 하고 실패할 경우 에러가 발생하기 때문에 앱이 꺼지는 것이었다. 그래서 이 부분은 안전하게 guard let 으로 옵셔널 바인딩 처리를 해주고 as! 가 아닌 as?를 사용함으로써, 오류가 해결되었다.


```swift
guard let ann = view.annotation as? MKPointAnnotation else { return }
```


#### *4. 효율적인 API 관리*


🧷  문제


API 가 여러번 호출되기 때문에 이를 효율적으로 관리할 수 있는 방법을 고민해야 했다. 


🎨 해결


싱클톤 패턴은 다른 클래스들과 자원공유가 쉽고 한 번에 한 인스턴스만 생성하므로 메모리 낭비를 방지할 수 있기 때문에 효율적인 API 관리를 위해 싱클톤 패턴을 선택했다. 

 

```swift
class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func searchImage(query: String, completionHandler: @escaping ([String]) -> ()) {
        
        let urlString = "\(EndPoint.imageSearchURL)독립서점\(query)&display=6&start=1&sort=sim"
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret]
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
                switch response.result {
                    
                        case .success(let value):
                            let json = JSON(value)
                            let data = json["items"]
                            var imageList: [String] = []
                    
                            if data.count >= 6 {
                                for num in 0...5 {
                                    let value = data[num]["link"].stringValue
                                    imageList.append(value)
                                }
                            } else {
                                if data.count == 0 {
                                    
                                } else {
                                    for num in 0...data.count - 1{
                                        let value = data[num]["link"].stringValue
                                        imageList.append(value)
                                    }
                                }
                            }
                    
                    completionHandler(imageList)
                            

                        case .failure(let error):
                            print(error)
                        }
                    }
        
        
    
    }
}
```


#### *5. 1번의 리젝 이슈*


🧷  문제 


권한 허용 문구가 구체적이지 않아 리젝을 당했다. 


<img width="671" alt="스크린샷 2023-01-11 오전 11 55 45" src="https://user-images.githubusercontent.com/90595710/211734853-bbf29871-f458-4495-9d76-f5a03d0a62fc.png">


🎨 해결


그래서 좀 더 구체적이고 상세하게 권한 허용 문구를 작성하여 심사에 통과할 수 있었다.

### 🍀 *앞으로 업데이트 해야할 부분*

원래 지금 구현된 것보다 조금 더 디테일한 부분까지 완성도있게 해서 출시를 하고 싶었는데, 생각보다 시간이 빡빡하고 마지막에 버그를 잡는데에 대부분의 시간을 투자해서 일단 전체적인 기능이 오류없이 동작하는 것까지 확인하고 출시를 하게 되었던 것 같다. (나머지는 미래의 내가 수고하겠지..) 그래서 앞으로 남은 업데이트는 지금까지 받은 피드백과 시간이 부족해서 구현하지 못한 디테일한 기능들을 구현하는 데에 집중하고자 한다.

- **포토탭에 하나의 Cell만 정중앙에 보이도록 만들기**

원래 CollectionViewCell을 넘길 때 화면 정중앙에 Cell을 하나씩만 보이게 만들고 싶었는데, 시간도 부족하고 어떻게 해야할지 감이 잘 잡히지 않아서 우선은 최대한 중앙에 보이도록 만들긴 했지만 주변 지인들로부터 화면 중앙에 포토카드가 보였으면 좋겠다는 피드백을 들어서 이 부분에 대한 레이아웃을 어떻게 잡아야 할지 좀 더 고민해보는 시간이 필요할 것 같다는 생각이 든다.

- **포토카드를 한 번에 모아서 볼 수 있는 기능**

위와 같은 피드백을 주신 분도 있는가 하면, 사진을 넘기는 방식이 아닌 한 화면에 다 모아서 볼 수도 있으면 좋겠다는 피드백을 주신 분도 계셨다. 그래서 포토카드를 다양한 방식으로 보일 수 있도록 기능을 다양화할 수 있도록 업데이트를 해볼 것이다.

- **포토탭에 대한 Tutorial 필요**

시간이 부족해서 캘린더탭과는 달리 포토탭에는 따로 Tutorial을 작성하지 않았는데, 이 부분에 대한 피드백이 들어와서 이 부분도 추후 업데이트 때 추가할 예정이다. 포토탭을 처음 들어갔을 때, 빈 화면이 나오는데 사용자 관점에서 이 탭은 어떤 탭인지 인지하기 어렵다고 한다. 따라서 이 부분에 대한 추가적인 Tutorial 이 필요할 것 같다는 판단이 들어 이 부분도 추후에 업데이트를 해볼 예정이다.

- **백업 / 복구 기능**

### 📌 *느낀점*

이번 출시 프로젝트를 진행하면서, AppStore에 출시까지의 일련의 과정을 경험해 볼 수 있었고 오류를 해결하는 능력을 많이 키울 수 있었던 것 같다. 처음 앱 출시를 진행하다 보니, 돌아보면 미숙했던 부분도 많고 다시 돌아가면 더 잘할 수 있을 것 같은 부분도 많이 있지만 그래도 그런 시간들이 있었기 때문에 더 많이 성장할 수 있었던 것 같다는 생각이 든다. 16일이라는 기간이 짧은 시간은 아니었던 만큼, 체력적으로 힘든 시간도 있었고 매일이 오류와의 전쟁이었지만 출시하고 AppStore에 내 이름으로 앱이 올라가고 나니 그동안의 힘들었던 것들이 다 날라갈 만큼 뿌듯했던 경험이었던 것 같다. 앞으로는 북트립을 잘 관리해서, 사용자들이 사용하기에 편리한 앱으로 만들어나가고 싶다.
