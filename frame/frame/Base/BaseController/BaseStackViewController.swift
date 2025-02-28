//
//  BaseStackViewController.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation

class BaseStackViewController: BaseViewController, UIScrollViewDelegate {
    
    lazy var stackMain: UIStackView = {
        let view = UIStackView.init()
        view.axis = .vertical
        return view
    }()
    
    lazy var scrollMain: UIScrollView = {
        let view = UIScrollView.init()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: safeBottom, right: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollMain.delegate = self
        self.viewContent.addSubview(scrollMain)
        scrollMain.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollMain.addSubview(stackMain)
        stackMain.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(scrollMain)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
