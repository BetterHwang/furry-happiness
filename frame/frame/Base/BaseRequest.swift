//
//  BaseRequest.swift
//  frame
//
//  Created by apple on 2021/4/29.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol BaseRequestDelegate {
    associatedtype `Type`: BaseModel
    
    func onRecv(url: String, model: `Type`?)
    func onFailed(url: String, error: NSError?)
}

class BaseRequest {
    class func config(timeout: TimeInterval) {
        SessionManager.default.session.configuration.timeoutIntervalForRequest = timeout
        SessionManager.default.adapter = BaseRequestAdapter()
//        SessionManager.default.retrier = BaseRequestRetrier()
    }
    
    @discardableResult class func request<T: BaseModel>(
        urlString: String,
        params: [String: Any],
        method: HTTPMethod = .post,
        viewModel: BaseViewModel? = nil,
        entity: BaseEntity<T>? = nil,
        block: ((_ result: Bool, _ model: T?, _ error: NSError?)->Void)? = nil,
        showLoading: Bool = false,
        loadingView: HBLoadingView? = nil
        /*, delegate: BaseRequestDelegate*/) -> Request {
        
        let request = SessionManager.default.request(urlString, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (dataResponse) in
                switch (dataResponse.result) {
                case .success(let value):
                    guard let model = Mapper<BaseModelRet<T>>().map(JSONObject: value) else {
                        DispatchQueue.main.async {
                            let error = NSError.init(domain: "Mapper Parse Error", code: -1, userInfo: ["msg" : "ObjectMapper解析错误"])
                            viewModel?.onRecv(urlString: urlString, result: false, dataModel: nil, error: error)
                            entity?.onFailed(url: urlString, error: error)
                            block?(false, nil, error)
                        }
                        return
                    }
                    
                    if model.ret != 0 {
                        DispatchQueue.main.async {
                            let error = NSError.init(domain: "JSON Data Format Error", code: model.ret ?? -2, userInfo: ["msg" : model.msg ?? ""])
                            viewModel?.onRecv(urlString: urlString, result: false, dataModel: nil, error: error)
                            entity?.onFailed(url: urlString, error: error)
                            block?(false, nil, error)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        viewModel?.onRecv(urlString: urlString, result: true, dataModel: model.data, error: nil)
                        entity?.onRecv(url: urlString, model: model.data)
                        block?(true, model.data, nil)
                    }
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        viewModel?.onRecv(urlString: urlString, result: false, dataModel: nil, error: error as NSError)
                        entity?.onFailed(url: urlString, error: error as NSError)
                        block?(false, nil, error as NSError)
                    }
                    break
                }
            }
        
        return request
    }
}

// 添加公共参数 / 请求重定向(重新创建URLRequest返回)
class BaseRequestAdapter: RequestAdapter {
    fileprivate static var header_default: HTTPHeaders = [
        "Authorization": "",
        "Content-Type": "application/json",
        "osversion": "iphone\(UIDevice.current.systemVersion)",
        "version": "",
        "network": "",
        "platform": "ios",
        "uuid": "",
        "locationx": "0",
        "locationy": "0",
        "Accept": "application/json"
    ]
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        let dateNow = Date()
        let timeStamp = Int64(dateNow.timeIntervalSince1970)
        request.setValue("timeStamp", forHTTPHeaderField: "\(timeStamp)")
        
        return urlRequest
    }
}

// 重新请求
class BaseRequestRetrier: RequestRetrier {
    var repeatCount: Int = 0
    let maxCount: Int = 3
    let timeDelay: TimeInterval = 2
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if repeatCount < maxCount {
            completion(true, timeDelay)
            repeatCount += 1
        }else {
            completion(false, timeDelay)
        }
    }
}
