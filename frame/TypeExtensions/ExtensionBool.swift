//
//  ExtensionBool.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation

//Bool类型扩展
extension Bool{
    
    func stringValue() -> String {
        if self {
            return "true"
        }else{
            return "false"
        }
    }
    
    func toString(_ format: String) -> String {
        return String(format: format, self as CVarArg)
    }
}
