//
//  BaseEntity.swift
//  frame
//
//  Created by apple on 2021/4/30.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class BaseEntity<T: BaseModel>: BaseRequestDelegate {
    typealias `Type` = T
    var model: T? = nil
    
    func onFailed(url: String, error: NSError?) {
        
    }
    
    func onRecv(url: String, model: T?) {
        self.model = model
        
    }
}

