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
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.interactivePopGestureRecognizer == gestureRecognizer && (self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0]) {
            return false
        }
        
        return false
    }
}
