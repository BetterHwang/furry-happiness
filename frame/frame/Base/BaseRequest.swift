//
//  BaseRequest.swift
//  frame
//
//  Created by apple on 2021/4/29.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation
import Alamofire
import Moya

protocol HBRequestRetDelegate {
    func onRecv(model: BaseModel?)
}

class BaseRequest {
    class func post(url: String, params: [String: Any], delegate: HBRequestRetDelegate) {
    }
}
