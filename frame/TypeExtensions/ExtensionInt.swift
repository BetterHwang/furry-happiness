//
//  ExtensionInt.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation

//Int类型扩展
extension Int {
    
    var stringValue: String {
        return NSString(format: "%d", self) as String
    }
    
    func toString(format: String) -> String {
        return NSString(format: format, self) as String
    }
}

extension UInt {
    
    var stringValue: String {
        return NSString(format: "%lld", self) as String
    }
    
    func toString(format: String) -> String {
        return NSString(format: format, self) as String
    }
}
