## *북트립 개인 출시 프로젝트 (2022년 9월 13일 ~ 2022년 9월 29일)*

##### 1. 앱 이름 : 북트립 
##### 2. 앱 소개 : 지도를 통해 근처 가까운 독립서점에 대한 정보를 찾고 독립서점에 대한 방문기록을 날짜별로 저장하는 기능을 통해 독립서점을 좀 더 즐겁게 이용할 수 있도록 도와주는 앱
##### 3. 앱 기능 : 독립서점 위치 정보 제공 기능, 독립서점 상세 정보 제공 기능, 날짜별 독립서점 방문기록 저장 기능, 독립서점 방문기록 기반 포토카드 생성 기능, 독립서점 방문 사진 인스타그램 공유 기능
##### 4. 디자인 패턴: MVC
##### 5. 화면: UIKit, SnapKit, AutoLayout
##### 6. 데이터베이스: Realm
##### 7. 서버: Firebase Analytics
##### 8. 라이브러리: Alamofire, FSCalendar, IQKeyboardManager, KingFisher, Mantis, SwiftyJSON, Toast, Mapkit

### *🎯기술 명세* 
*  `SnapKit ` 을 활용하여 코드 베이스로  `Auto Layout ` 구현
*  `Decodable ` 을 이용해 독립서점  `JSON ` 데이터 설계 및 처리
*  `MapKit ` 과  `CLLocation ` 을 이용해 현재 위치와 독립서점 Annotation 표시 기능 구현
* 사용자가 저장한 독립서점은  `Realm `의  `Filter ` 기능을 활용해 저장된 독립서점만 Annotation 표시
*  `Naver Image Search API ` 를 활용해 독립서점 별 이미지 표현
*  `Naver Blog Search API ` 를 활용해 독립서점 별 블로그 리뷰 표현
*  `FSCalendar ` 를 이용해 캘린더 기능을 구현하고  `Realm ` 을 활용해  `CRUD/정렬 기능 ` 구현
*  `UIGraphicsImageRenderer ` 를 통해  `FileManager ` 의  `Document ` 에 저장되는 이미지 용량 처리
*  `Firebase Cloud Messaging ` 을 통해 푸쉬 알림 기능 구현
*  `Firebase Analytics ` 을 통해 사용자 Event 분석 기능 구현
