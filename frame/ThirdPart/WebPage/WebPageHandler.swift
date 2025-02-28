//
//  WebPageHandler.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation
import WebKit

class WebPageHandler: NSObject {
    static let PROTOCOL_HOST = "127.0.0.1"
    
    static func handle(url: URL?) {
        guard let url = url else {
            return
        }
        
        let urlPath = url.absoluteString
        if urlPath.starts(with: "tel://") || urlPath.starts(with: "telprompt://") {
            UIApplication.shared.open(url)
            return
        }
        
        var host: String?
        var path: String?
        if #available(iOS 16.0, *) {
            host = url.host()
            path = url.path()
        }else {
            host = url.host
            path = url.path
        }
        
        guard let host = host, host == WebPageHandler.PROTOCOL_HOST, let path = path else {
            return
        }
        
        var params = [String: Any]()
        if #available(iOS 16.0, *) {
            params = url.query()?.queryToDict() ?? [:]
        } else {
            // Fallback on earlier versions
            params = url.query?.queryToDict() ?? [:]
        }
        
        switch path {
        default:
            break
        }
    }
    
    static func cleanCache() {
        let dateFrom: Date = Date.init(timeIntervalSince1970: 0)
        
        if #available(iOS 9.0, *) {
            
            let websiteDataTypes: Set = WKWebsiteDataStore.allWebsiteDataTypes()
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
                
            }
        }else {
            
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            let cookiesFolderPath = libraryPath + "/Cookies"
            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
            
        }
    }
}

extension WebPageHandler: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.previousFailureCount == 0) {
            
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }else {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,nil)
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow);
    }
    
}

//extension WebPageHandler: WKScriptMessageHandler {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        // web js 调用原生
//    }
//}

extension String {
    func queryToDict() -> [String: Any] {
        
        var dict: [String: Any] = [:]
        let array = self.components(separatedBy: "&")
        for item in array {
            let kv = item.components(separatedBy: "=")
            if(kv.count != 2){
                continue
            }
            dict[kv[0]] = kv[1]
        }
        
        return dict
    }
}
