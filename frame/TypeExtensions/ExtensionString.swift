//
//  ExtensionString.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation

//String类型扩展

extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var intValue: Int {
        return (self as NSString).integerValue
    }
    
    var int32Value: Int32 {
        return (self as NSString).intValue
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var arrayUInt8Value: [UInt8] {
        return Array(self.utf8)
    }
    
    func substring(start: Int, length: Int) -> String {
        if 0 > start || start >= count || 0 >= length {
            return ""
        }
        
        let indexStart = index(startIndex, offsetBy: start)
        let indexEnd = index(startIndex, offsetBy: start + length)
        return String(self[indexStart..<indexEnd])
    }
    
    func firstIndexOfCharacter(_ char: Character) -> Int? {
        if let index = self.firstIndex(of: char) {
            return self.distance(from: self.startIndex, to: index)
        }
        
        return nil
    }
    
    func isContainCharacter(_ char: Character) -> Bool {
        if self.firstIndexOfCharacter(char) != nil {
            return true
        } else {
            return false
        }
    }
    
    func stringByTransformFromChineseToPinyin() -> String {
        if (0 >= self.count) {
            return self
        }
        
        let ms = NSMutableString(string: self)
        
        CFStringTransform(ms, nil, kCFStringTransformMandarinLatin, false)
        
        if (CFStringTransform(ms, nil, kCFStringTransformStripDiacritics, false)) {
            return ms as String
        }
        
        return self
    }
    
    func getHeight(limitedWidth: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
        let limitedSize = CGSize(width: limitedWidth, height: CGFloat.greatestFiniteMagnitude)
        let size = self.boundingRect(with: limitedSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return size.height
    }
    
    func getWidth(limitedHeight: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
        let limitedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: limitedHeight)
        let size = self.boundingRect(with: limitedSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return size.width
    }
}
