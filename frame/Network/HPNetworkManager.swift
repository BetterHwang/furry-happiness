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
    optional func networkManagerChangeReachability(status: NetworkStatus)
}

class HPNetworkManager: NSObject {
    private static let _inst = HPNetworkManager()
    
//    private let _reach = Reachability.reachabilityForInternetConnection()
    private let _reach = Reachability.init(hostName: "http://www.baidu.com")
    class var sharedInstance: HPNetworkManager {
        return _inst
    }
    
    private var _statusTemp: NetworkStatus = .NotReachable
    private var _delegate: HPNetworkManagerDelegate?
    
    func checkReachability(hostName: String) -> String {
        let reach = Reachability.init(hostName: hostName)
        switch reach.currentReachabilityStatus() {
        case .NotReachable:
            break
        case .ReachableViaWiFi:
            break
        case .ReachableViaWWAN:
            break
        default:
            break
        }
        return ""
    }
    
    func startListen(delegate: HPNetworkManagerDelegate?) {
        _reach.stopNotifier()
        _reach.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPNetworkManager.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
    }
    
    func stopListen() {
        _reach.stopNotifier()
    }
    
    func reachabilityChanged(notice: NSNotification) {
        
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
        
        if _statusTemp != _reach.currentReachabilityStatus() {
            _delegate?.networkManagerChangeReachability?(_reach.currentReachabilityStatus())
        }
    }
    
    //获取信号强弱等级
    //会被App Store 拒绝的
    //有问题 都是0
    func getNetworkLevel() -> Int32 {
        return _reach.getSignLevel()
    }
    
}
