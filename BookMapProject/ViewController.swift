//
//  ViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/13.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        searchPlace(query: "최인아책방")
    }
    
    func searchPlace(query: String) {
        let urlString = "\(EndPoint.placeURL)query=\(query)"
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret]
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")

                       
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    


}

