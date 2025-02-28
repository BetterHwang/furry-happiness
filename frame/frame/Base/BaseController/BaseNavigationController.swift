//
//  BaseNavigationController.swift
//  frame
//
//  Created by apple on 2021/5/19.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            let barBtnBack = UIBarButtonItem.init(image: UIImage.init(named: "icon_navigation_back_black"), style: .plain, target: self, action: #selector(onNavigationBack))
            viewController.navigationItem.leftBarButtonItems = [barBtnBack]
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func onNavigationBack() {
        guard let lastController = self.viewControllers.last else {
            return
        }
        
        if lastController is BaseViewController, let controller = lastController as? BaseViewController {
            controller.onNavigationBack()
        }else {
            self.popViewController(animated: true)
        }
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.interactivePopGestureRecognizer == gestureRecognizer && (self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0]) {
            return false
        }
        
        return false
    }
}
