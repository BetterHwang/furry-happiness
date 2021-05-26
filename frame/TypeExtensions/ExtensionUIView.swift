//
//  ExtensionUIView.swift
//  frame
//
//  Created by yl on 16/8/24.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation
import UIKit
var UIView_LoadCount: UInt8 = 0

extension UIView {
    var x: CGFloat {
        get{
            return frame.origin.x
        }
        set(newValue) {
            frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get{
            return frame.origin.y
        }
        set(newValue) {
            frame.origin.y = newValue
        }
    }
    
    
    var centerX: CGFloat {
        get{
          return center.x
        }
        set(newValue) {
           center.x = newValue
        }
    }
    
    var centerY: CGFloat {
        get{
          return center.y
        }
        set(newValue) {
            center.y = newValue
        }
    }
    
    var width: CGFloat {
        get{
            return frame.size.width
        }
        set(newValue) {
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get{
            return frame.size.height
        }
        set(newValue) {
            frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get{
            return bounds.size
        }
        set(newValue) {
            frame.size = newValue
        }
    }
    
    var origin: CGPoint {
        get{
            return frame.origin
        }
        set(newValue) {
            frame.origin = newValue
        }
    }
    
//    var _loadCount: Int {
//        get {
//            return objc_getAssociatedObject(self, &UIView_LoadCount) as? Int ?? 0
//        }
//        set {
//            objc_setAssociatedObject(self, &UIView_LoadCount, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
//        }
//    }
}

// MARK: -截屏功能
extension UIView {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
