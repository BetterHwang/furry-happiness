//
//  WebViewController.swift
//  frame
//
//  Created by yl on 16/7/26.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var webViewContent: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URLRequest(url: URL(string: "http://www.baidu.com/")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        webViewContent.load(request)
        
        webViewContent.uiDelegate = self
        webViewContent.navigationDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //获取HTML标题
        let htmlTitle = "document.title"
        
        webView.evaluateJavaScript(htmlTitle) { [weak self] data, error in
            guard let titlePage = data as? String else {
                return
            }
            
            self?.title = titlePage
        }
//        //获取网页的某个值
//        let htmlNum = "document.getElementById('kw').innerText"
//        let htmlNumInfo = webView.stringByEvaluatingJavaScript(from: htmlNum)
//        NSLog("\(htmlNumInfo)")
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
}
