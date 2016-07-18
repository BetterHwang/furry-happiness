//
//  HPDeviceInfo.swift
//  frame
//
//  Created by yl on 16/6/3.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import CoreTelephony

class HPDeviceInfo: NSObject {
    class func getOwnerName() -> String? {
        return UIDevice().name
    }
    
    class func getDeviceModel() -> String? {
        return UIDevice().model
    }
    
    class func getSystemName() -> String? {
        return UIDevice().systemName
    }
    
    class func getSystemVersion() -> String? {
        return UIDevice().systemVersion
    }
    
    class func getUUID() -> String? {
        return UIDevice.currentDevice().identifierForVendor?.UUIDString
    }
    
    class func getScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    class func getScreenScale() -> CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    class func getMobileOperatorName() -> String? {
        let info = CTTelephonyNetworkInfo()
        return info.subscriberCellularProvider?.carrierName
    }
    
    /***CTRadioAccessTechnologyGPRS      	//介于2G和3G之间，也叫2.5G ,过度技术
    CTRadioAccessTechnologyEdge       	//EDGE为GPRS到第三代移动通信的过渡，EDGE俗称2.75G
    CTRadioAccessTechnologyWCDMA
    CTRadioAccessTechnologyHSDPA        	//亦称为3.5G(3?G)
    CTRadioAccessTechnologyHSUPA        	//3G到4G的过度技术
    CTRadioAccessTechnologyCDMA1x   	//3G
    CTRadioAccessTechnologyCDMAEVDORev0    //3G标准
    CTRadioAccessTechnologyCDMAEVDORevA
    CTRadioAccessTechnologyCDMAEVDORevB
    CTRadioAccessTechnologyeHRPD     	//电信使用的一种3G到4G的演进技术， 3.75G
    CTRadioAccessTechnologyLTE   		//接近4G
     */
    class func getMobileNetworkType() -> String? {
        let info = CTTelephonyNetworkInfo()
        return info.currentRadioAccessTechnology
    }
}
