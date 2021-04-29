//
//  ExtensionDouble.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation

//Double类型扩展
extension Double {
    func toString(_ format: String = "%lf") -> String {
        return String(format: format, self)
    }
}

