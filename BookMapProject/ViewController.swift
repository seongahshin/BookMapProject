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

class ViewController: UIViewController {

    let bookData: dummyData = dummyData()
    
    // Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    var locationButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .brown
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        
        // Location3. 프로토콜 연결
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        locationManager.requestWhenInUseAuthorization()
        
        bookData.decode()
        configureUI()
        setRegion(center: center)
        
    }
    
    
    @objc func uploadLocation() {
        
    }
    
    func configureUI() {
        [mapView].forEach {
            view.addSubview($0)
        }
        
        mapView.addSubview(locationButton)
        
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(-20)
            make.trailing.equalTo(-20)
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
        print(bookData.decode())
        
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



// Location4. 프로토콜 선언
extension ViewController: CLLocationManagerDelegate {
    
    // Location5. 사용자의 위치를 성공적으로 가져온 경우에 해당
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
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
        print(#function)
    }
    
    // Location9. 사용자의 권한 상태가 바뀔 때를 알려줌
    // 거부했다가 설정에서 변경했거나, notDetermined에서 허용을 했거나 등
    // 허용을 해서 위치를 가져오는 도중에, 설정에서 거부하고 돌아온다면?
    // iOS 14 이상:
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    
}


extension ViewController: MKMapViewDelegate {
    
    // 지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}

