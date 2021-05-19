//
//  HBMultiTabChildController.swift
//  frame
//
//  Created by apple on 2021/5/7.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

protocol HBMultiTabChildDelegate: NSObjectProtocol {
    func tabChildController(_ viewController: HBMultiTabChildController, scrollViewDidScroll scrollView: UIScrollView)
}

class HBMultiTabChildController: UIViewController {
    
    // 主要用来控制mainScrollView在上下滑动的时候在没到阈值的时候让child view相对静止
    public var offsetY: CGFloat = 0.0
    public var isCanScroll: Bool = false
    public weak var scrollDelegate: HBMultiTabChildDelegate?
    public func getScrollView () -> UIScrollView? {
        return nil
    }
}
