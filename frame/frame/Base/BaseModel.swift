//
//  BaseModel.swift
//  frame
//
//  Created by apple on 2021/4/29.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}

class BaseModelRet<T: BaseModel>: BaseModel {
    var ret: Int?
    var msg: String?
    var data: T?
    
    override func mapping(map: Map) {
        ret <- map["ret"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class BaseModelRetArray<T: BaseModel>: BaseModel {
    var ret: Int?
    var msg: String?
    var data: [T]?
    
    override func mapping(map: Map) {
        ret <- map["ret"]
        msg <- map["msg"]
        data <- map["data"]
    }
}
