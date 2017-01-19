//
//  HPNetworkManager.swift
//  frame
//
//  Created by yl on 16/6/3.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import SystemConfiguration

@objc protocol HPNetworkManagerDelegate {
    @objc optional func networkManagerChangeReachability(_ status: NetworkStatus)
}

class HPNetworkManager: NSObject {
    fileprivate static let _inst = HPNetworkManager()
    
//    private let _reach = Reachability.reachabilityForInternetConnection()
    fileprivate let _reach = Reachability.init(hostName: "http://www.baidu.com")
    class var sharedInstance: HPNetworkManager {
        return _inst
    }
    
    fileprivate var _statusTemp: NetworkStatus = .NotReachable
    fileprivate var _delegate: HPNetworkManagerDelegate?
    
    func checkReachability(_ hostName: String) -> String {
        let reach = Reachability.init(hostName: hostName)
        switch reach!.currentReachabilityStatus() {
        case .NotReachable:
            break
        case .ReachableViaWiFi:
            break
        case .ReachableViaWWAN:
            break
        }
        return ""
    }
    
    func startListen(_ delegate: HPNetworkManagerDelegate?) {
        _reach?.stopNotifier()
        _reach?.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(HPNetworkManager.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    
    func stopListen() {
        _reach?.stopNotifier()
    }
    
    func reachabilityChanged(_ notice: Notification) {
        
//        switch _reach.currentReachabilityStatus() {
//        case .NotReachable:
//            break
//        case .ReachableViaWiFi:
//            break
//        case .ReachableViaWWAN:
//            break
//        default:
//            break
//        }
        
        if _statusTemp != _reach?.currentReachabilityStatus() {
            _delegate?.networkManagerChangeReachability?((_reach?.currentReachabilityStatus())!)
        }
    }
    
    //获取信号强弱等级
    //会被App Store 拒绝的
    //有问题 都是0
    func getNetworkLevel() -> Int32 {
        return _reach!.getSignLevel()
    }
    
}
