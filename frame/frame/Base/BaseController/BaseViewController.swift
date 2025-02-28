//
//  BaseViewController.swift
//  frame
//
//  Created by apple on 2021/5/19.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    
    var showNav: Bool = true {
        didSet {
            if showNav {
                self.viewNav.snp.makeConstraints { make in
                    make.height.equalTo(0)
                }
            }else {
                self.viewNav.snp.makeConstraints { make in
                    make.height.equalTo(navigationHeight)
                }
            }
        }
    }
    
    lazy var viewNav: BaseNavigationView = {
        let view = BaseNavigationView.init()
        return view
    }()
    
    lazy var viewContent: UIView = {
        let view = UIView.init()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(viewNav)
        viewNav.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navigationHeight)
        }
        
        self.view.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(viewNav.snp.bottom)
        }
    }
    
    func onNavigationBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        
    }
    
    func onLoadDataFinished() {
        
    }
}
