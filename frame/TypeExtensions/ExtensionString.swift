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
    
    var length : Int {
        return (self as NSString).length
    }
    
    func firstIndexOfCharacter(char: Character) -> Int? {
        if let index = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(index)
        }
        return nil
    }
    
    func isContainCharacter(char: Character) -> Bool {
        
        if let index = self.firstIndexOfCharacter(char) {
            return true
        } else {
            return false
        }
    }
    
    func isHasSameStr(str:String) -> Bool {
        
        var flag =  (str as NSString).rangeOfString(self).length > 0
        if !flag {
            flag = (self as NSString).rangeOfString(str).length > 0
        }
        return flag
    }
    
    func stringByTransformFromChineseToPinyin() -> String {
        
        if (self.length > 0) {
            let ms = NSMutableString(string: self)
            
            CFStringTransform(ms, nil, kCFStringTransformMandarinLatin, false)
            
            if (CFStringTransform(ms, nil, kCFStringTransformStripDiacritics, false)) {
                return ms as String
            }
        }
        
        return self
    }
}
