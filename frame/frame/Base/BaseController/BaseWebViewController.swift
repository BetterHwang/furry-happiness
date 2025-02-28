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
    
    lazy var webView: WKWebView = {
        let view = WKWebView.init()
        return view
    }()
    
    lazy var progressView: LineProgressView = {
        let view = LineProgressView.init()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
