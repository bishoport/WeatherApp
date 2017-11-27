//
//  InfoWebViewController.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit
import WebKit


class InfoWebViewController: UIViewController , WKUIDelegate , WKNavigationDelegate {

    
    var loadingActivityIndicator: UIActivityIndicatorView?
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "http://www.zonaapp.es/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        loadingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        loadingActivityIndicator?.center = view.center
        loadingActivityIndicator?.startAnimating()
        view.addSubview(loadingActivityIndicator!)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingActivityIndicator?.isHidden = true
        
    }

    
    

}
