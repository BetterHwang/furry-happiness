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
    var _loadCount: Int {
        get {
//            if let obj = objc_getAssociatedObject(self, &UIView_LoadCount) as? Int {
//                return obj
//            }else {
//                let initValue = 0
//                objc_setAssociatedObject(self, &UIView_LoadCount, initValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                return initValue
//            }
            return objc_getAssociatedObject(self, &UIView_LoadCount) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &UIView_LoadCount, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class func getStringSizeWithLimitedWidth(_ content:String, width:CGFloat, font:UIFont) -> CGSize {
        
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.left
        paragraphStyle.minimumLineHeight = font.lineHeight
        paragraphStyle.maximumLineHeight = font.lineHeight
        paragraphStyle.lineSpacing = 2.0
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        let frame = content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).boundingRect(with: size,
                                                                                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                                                                                    attributes: attributes,
                                                                                                                                    context: nil)
        
        return frame.size
    }
    
    class func getStringSizeWithLimitedHeight(_ content:String, heigth:CGFloat, font:UIFont) -> CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: heigth)
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paragraphStyle.alignment = NSTextAlignment.left
        paragraphStyle.minimumLineHeight = font.lineHeight
        paragraphStyle.maximumLineHeight = font.lineHeight
        paragraphStyle.lineSpacing = 2.0
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        let frame = content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).boundingRect(with: size,
                                                                                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                                                                                    attributes: attributes,
                                                                                                                                    context: nil)
        return frame.size
    }
}
