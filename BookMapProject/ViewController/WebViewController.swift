//
//  WebViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/16.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var blogURL: String = ""
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewDidLoad() {
        let URL = URL(string: blogURL)
        let request = URLRequest(url: URL!)
        webView.load(request)
    }
    
    
}
