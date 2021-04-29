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
    func toString(_ format: String = "%f") -> String {
        return String(format: format, self)
    }
}

