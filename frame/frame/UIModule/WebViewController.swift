//
//  WebViewController.swift
//  frame
//
//  Created by yl on 16/7/26.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webViewContent: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URLRequest(url: URL(string: "http://www.baidu.com/")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        webViewContent.loadRequest(request)
        
        webViewContent.delegate = self
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

    func webViewDidFinishLoad(_ webView: UIWebView) {
        //获取所有的HTML
//        let allHtml = "document.documentElement.innerHTML"
//        let allHtmlInfo = webView.stringByEvaluatingJavaScriptFromString(allHtml)
//        NSLog("\(allHtmlInfo)")
        
        //获取HTML标题
        let htmlTitle = "document.title"
        let htmlTitleInfo = webView.stringByEvaluatingJavaScript(from: htmlTitle)
        NSLog("\(htmlTitleInfo)")
        self.title = htmlTitleInfo
        
        //获取网页的某个值
        let htmlNum = "document.getElementById('kw').innerText"
        let htmlNumInfo = webView.stringByEvaluatingJavaScript(from: htmlNum)
        NSLog("\(htmlNumInfo)")
    }
}
