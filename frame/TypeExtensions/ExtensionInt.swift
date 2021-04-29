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
    func toString(_ format: String = "%d") -> String {
        return String(format: format, self)
    }
}

extension UInt {
    func toString(_ format: String = "%u") -> String {
        return String(format: format, self)
    }
}
