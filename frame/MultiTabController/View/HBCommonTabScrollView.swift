//
//  HBCommonTabScrollView.swift
//  frame
//
//  Created by apple on 2021/5/7.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class HBCommonTabScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    public var scrollViewWhites: Set<UIScrollView>?
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let setOfScrollView = scrollViewWhites else {
            return true
        }
        
        for item in setOfScrollView {
            if let view = otherGestureRecognizer.view, view == item {
                return true
            }
        }
        
        return true
    }
}
