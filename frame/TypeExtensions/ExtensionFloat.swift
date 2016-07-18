//
//  ExtensionFloat.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation

//Float类型扩展
extension Float {
    
    var stringValue: String {
        return NSString(format: "%f", self) as String
    }
    
    func toString(format: String) -> String {
        return NSString(format: format, self) as String
    }
}

