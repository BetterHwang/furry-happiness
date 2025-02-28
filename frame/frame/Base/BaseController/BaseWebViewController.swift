//
//  BaseWebViewController.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation
import WebKit

class BaseWebViewController: BaseViewController {
    static let shardPool = WKProcessPool()
    
    var useUrlTitle: Bool = false
    
    lazy var webView: WKWebView = {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let config = WKWebViewConfiguration.init()
        config.websiteDataStore = WKWebsiteDataStore.default()
        config.processPool = BaseWebViewController.shardPool
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.preferences = preferences
        if #available(iOS 14.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
        }
        
        let view = WKWebView.init(frame: CGRect.zero, configuration:config)
        view.allowsBackForwardNavigationGestures = true
        view.allowsLinkPreview = true
        
        return view
    }()
    
    lazy var progressView: LineProgressView = {
        let view = LineProgressView.init()
        return view
    }()
    
    lazy var handlerWeb: WebPageHandler = {
        let handler = WebPageHandler()
        return handler
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil);
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        
        let userContentController = webView.configuration.userContentController
//        userContentController.add(self, name: BasicWebViewController.GET_NATIVE_USER_TOKEN)
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(3)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "title") {
            if (object as AnyObject? === self.webView) {
                if(useUrlTitle == true) {
                    self.navigationItem.title = self.webView.title
                }
            }
        }else if (keyPath == "estimatedProgress") {
            progressView.progress = Float(self.webView.estimatedProgress)
            print("estimatedProgress>>>\( self.webView.estimatedProgress)")
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
}

extension BaseWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {//alert
        var ms = message
//        if message == "请先登录" {
//            
//            let model = UserManager.sharedInstance.getUser()
//            if model.customertype == "2000" || UserManager.sharedInstance.isLoginSuccess() == false{
//                ms = "网络波动异常,请退出页面重试"
//            }
//        }
        let alertController = UIAlertController(title: "提示", message: ms, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { (action) in
            completionHandler()
        }))
        present(alertController, animated: true,completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {//confirm
        var ms = message
//        let model = UserManager.sharedInstance.getUser()
//        if message == "请先登录" {
//            if model.customertype == "2000" || UserManager.sharedInstance.isLoginSuccess() == false{
//                ms = "网络波动异常,请退出页面重试"
//            }
//        }
        let alertController = UIAlertController(title: "提示", message: ms, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
//            if model.customertype == "2000" || UserManager.sharedInstance.isLoginSuccess() == false{
//                NotificationCenter.default.post(name:NSNotification.Name("visitorLogin"), object:nil)
//            }
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
//            if model.customertype == "2000" || UserManager.sharedInstance.isLoginSuccess() == false{
//                NotificationCenter.default.post(name:NSNotification.Name("visitorLogin"), object:nil)
//            }
            completionHandler(true)
        }))
        
        present(alertController, animated: true,completion: nil)
    }
    
    
}

extension BaseWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow);
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.previousFailureCount == 0) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }else {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,nil)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        let urlStr = webView.url?.absoluteString ?? ""
//        print("loadurl is \(urlStr) ")
//        if(urlStr.contains("/login")) {
//            let model = UserManager.sharedInstance.getUser()
//            if model.customertype == "2000" {
////                self.pop()
//            }
//            needRefreshPage = true
//        }else {
//            needRefreshPage = false
//        }
//        saveAuthorizationToLocalStorage()
        WebPageHandler.handle(url: webView.url)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.progress = 1
        
//        saveAuthorizationToLocalStorage()
//        setSysInfo()
//        if(webView.url?.absoluteString == self.pageUrl)
//        {
//            loadFirstPageIsComplet = true
//        }
//        
//        
//        webView.evaluateJavaScript(AppConstants.APPINJECTION) { (obj, error) in
//            print(error.debugDescription)
//        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        
//        print(webView.url?.absoluteString ?? "")
//        print("wkwebview error: didFail navigation --" + error.localizedDescription)
    }
    
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}
