//
//  ViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/13.
//

import UIKit
import CoreLocation
import MapKit

import Alamofire
import SwiftyJSON
import SnapKit
import RealmSwift
import FirebaseAnalytics

class ViewController: UIViewController {

    let bookData: dummyData = dummyData()
    let data = dummyData().decode()
    var infoList: [String] = []
    var imageList: [String] = []
    var blogList: [Blog] = []
    let localRealm = try! Realm()
    var tasks: Results<BookStore>!
    
    // Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "찾고 싶은 독립서점명을 입력해주세요"
        return view
    }()
    
    var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    var locationButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setImage(UIImage(systemName: "scope"), for: .normal)
        view.tintColor = Color.memoColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    var infoButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.3
        view.layer.borderColor = Color.memoColor.cgColor
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonBold, size: 15)
        return view
    }()
    
    var addressLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: FontManager.GangWonLight, size: 13)
        return view
    }()
    
    var arrowLabel: UILabel = {
        let view = UILabel()
        view.text = ">"
        view.textColor = Color.memoColor
        view.textAlignment = .center
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        
        // Location3. 프로토콜 연결
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        checkUserDeviceLocationServiceAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        configureUI()
        infoButton.addTarget(self, action: #selector(transitionButton), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationUpdatedButton), for: .touchUpInside)
        navigationItem.titleView = searchBar
        navigationItem.titleView?.backgroundColor = .white
        searchBar.delegate = self
        
        if #available(iOS 14.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "line.3.horizontal"), primaryAction: nil, menu: menu)
            self.navigationItem.rightBarButtonItem?.tintColor = Color.memoColor
        }
    }
    
    var menu: UIMenu {
        return UIMenu(title: "", options: [], children: menuItems)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "저장한 독립서점만 표시할래요!", handler: { _ in
                self.tasks = self.localRealm.objects(BookStore.self)
                let allAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(allAnnotations)
                self.mybookstoreAnnotation()
            }),
            
            UIAction(title: "전체 독립서점을 표시할래요!", handler: { _ in
                self.allbookstoreAnnotation()
            })
        ]
    }
    
    @objc func transitionButton() {
        let vc = DetailViewController()
        
        if !NetworkMonitor.shared.isConnected {
            let alert = UIAlertController(title: "실패", message: "데이터 연결이 되어있지 않습니다.", preferredStyle: UIAlertController.Style.alert)
            let badAction = UIAlertAction(title: "설정창으로 이동", style: .default) { (action) in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
            alert.addAction(badAction)
            present(alert, animated: false, completion: nil)
        } else {
            vc.storeInfoList = infoList
            vc.storImageList = imageList
            vc.getBlogList = blogList
            
            Analytics.logEvent("click_detail", parameters: [
            "name": infoList[0]
            ])
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func allbookstoreAnnotation() {
        
        for num in 0...data.count - 1 {
            let center = CLLocationCoordinate2D(latitude: data[num].latitude, longitude: data[num].longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = bookData.decode()[num].location
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func mybookstoreAnnotation() {
        
        if tasks.count > 0 {
            for num in 0...tasks.count - 1 {
                let center = CLLocationCoordinate2D(latitude: tasks[num].latitude, longitude: tasks[num].longitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = tasks[num].name
                mapView.addAnnotation(annotation)
            }
        }
        
        
    }
    
    @objc func locationUpdatedButton() {
//        locationManager.requestWhenInUseAuthorization()
        checkUserDeviceLocationServiceAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func configureUI() {
        [mapView].forEach {
            view.addSubview($0)
        }
        
        mapView.addSubview(searchBar)
        mapView.addSubview(locationButton)
        mapView.addSubview(infoButton)
        
        infoButton.addSubview(nameLabel)
        infoButton.addSubview(addressLabel)
        infoButton.addSubview(arrowLabel)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            make.trailing.equalTo(-10)
        }
        
        infoButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leftMargin.equalTo(20)
            make.trailing.equalTo(locationButton.snp.leadingMargin).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-35)
            make.height.equalTo(20)
            make.top.equalTo(5)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-35)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
        }
        
        arrowLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(nameLabel.snp.trailing).offset(5)
            make.right.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview().inset(15)
        }
        
    }
    
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

    
    func setRegion(center: CLLocationCoordinate2D) {

        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        for num in 0...bookData.decode().count - 1 {
            let center = CLLocationCoordinate2D(latitude: bookData.decode()[num].latitude, longitude: bookData.decode()[num].longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = bookData.decode()[num].location
            mapView.addAnnotation(annotation)
        }

    }
    

}

// 위치 관련된 메서드 (User Defined 메서드)
extension ViewController {
    
    // Location7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부
    // 위치 서비스가 켜져있다면 권한을 요청하고, 꺼져 있다면 커스텀 Allert으로 상황 알려주기
    // CLAuthorizationStatus
    // - denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
    // - restricted: 앱에서 권한 자체가 없는 경우 / 자녀 보호 기능 같은 걸로 아예 제한
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            // 인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져있어 위치 권한 요청을 못합니다.")
        }
        
    }
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치권한을 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인 (단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 위치 권한 요청
            // plist WhenInUse -> request 메서드 OK
//            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
        
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // 사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

// Location4. 프로토콜 선언
extension ViewController: CLLocationManagerDelegate {
    
    // Location5. 사용자의 위치를 성공적으로 가져온 경우에 해당
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // ex. 위도, 경도 기반으로 날씨 정보를 조회
        // ex. 지도를 다시 세팅
        
        
        if let coordinate = locations.last?.coordinate {
            
            let latitude = coordinate.latitude
            let longtitude = coordinate.longitude
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            setRegion(center: center)
        }
            
        
        
        // 위치 업데이트 멈춰!
        locationManager.stopUpdatingLocation()
    }
    
    // Location6. 사용자의 위치를 가져오지 못한 경우에 해당
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegion(center: center)
    }
    
    // Location9. 사용자의 권한 상태가 바뀔 때를 알려줌
    // 거부했다가 설정에서 변경했거나, notDetermined에서 허용을 했거나 등
    // 허용을 해서 위치를 가져오는 도중에, 설정에서 거부하고 돌아온다면?
    // iOS 14 이상:
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    
}


extension ViewController: MKMapViewDelegate {
    
    // 지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        locationManager.startUpdatingLocation()
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let ann = view.annotation as? MKPointAnnotation else { return }
            
        for num in 0...data.count - 1 {
            let data = bookData.decode()[num]
            if ann.title == data.location {
                
                nameLabel.text = ann.title!
                addressLabel.text = data.address
                infoList = [ann.title!, data.address, data.time, data.link]
                
                Analytics.logEvent("click_ann", parameters: [
                "name": infoList[0]
                ])
                
                APIManager.shared.searchImage(query: infoList[0]) { value in
                    self.imageList = value
                }

                APIManager.shared.searchBlog(query: infoList[0]) { value in
                    self.blogList = value
                }
                    
                infoButton.isHidden = false
                infoButton.backgroundColor = .white
            }
        }
            imageList.removeAll()
            blogList.removeAll()
            
    }
        
    
    
}

